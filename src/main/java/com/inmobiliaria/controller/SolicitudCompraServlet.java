package com.inmobiliaria.controller;

import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.dao.SolicitudDAO;
import com.inmobiliaria.model.DocumentoSolicitud;
import com.inmobiliaria.model.Propiedad;
import com.inmobiliaria.model.Solicitud;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controlador del modulo de Solicitudes de compra/arriendo y sus documentos.
 * Mapeado a /SolicitudCompraServlet.
 *
 * CLIENTE:
 *   action=crear            -> radica una solicitud de compra o arriendo.
 *   action=agregarDocumento -> sube (por URL) un documento a su solicitud.
 *   action=eliminarDocumento-> elimina un documento propio.
 *   action=cancelar         -> cancela su solicitud.
 * INMOBILIARIA:
 *   action=cambiarEstado    -> aprueba/rechaza (o pone en revision) una solicitud
 *                              de una de sus propiedades.
 */
public class SolicitudCompraServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final List<String> TIPOS_VALIDOS = Arrays.asList("COMPRA", "ARRIENDO");
    private static final List<String> ESTADOS_VALIDOS =
            Arrays.asList("PENDIENTE", "EN_REVISION", "APROBADA", "RECHAZADA", "CANCELADA");

    private final SolicitudDAO solicitudDAO = new SolicitudDAO();
    private final PropiedadDAO propiedadDAO = new PropiedadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("idUsuario") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String rol = (String) session.getAttribute("rol");
        int idUsuario = (Integer) session.getAttribute("idUsuario");

        try {
            if ("CLIENTE".equals(rol)) {
                List<Solicitud> solicitudes = solicitudDAO.listarPorCliente(idUsuario);
                request.setAttribute("solicitudes", solicitudes);
                request.setAttribute("documentos", cargarDocumentos(solicitudes));
                request.setAttribute("tituloPagina", "Mis Solicitudes - JSGE In-Mobiliaria");
                request.getRequestDispatcher("/dashboard/cliente/mis_solicitudes_compra.jsp")
                       .forward(request, response);

            } else if ("INMOBILIARIA".equals(rol)) {
                List<Solicitud> solicitudes = solicitudDAO.listarPorInmobiliaria(idUsuario);
                request.setAttribute("solicitudes", solicitudes);
                request.setAttribute("documentos", cargarDocumentos(solicitudes));
                request.setAttribute("tituloPagina", "Solicitudes de Compra/Arriendo - JSGE In-Mobiliaria");
                request.getRequestDispatcher("/dashboard/agente/gestion_solicitudes_compra.jsp")
                       .forward(request, response);

            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard/admin/index.jsp");
            }

        } catch (SQLException e) {
            throw new ServletException("Error de base de datos al listar las solicitudes.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("idUsuario") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String rol = (String) session.getAttribute("rol");
        int idUsuario = (Integer) session.getAttribute("idUsuario");
        String action = trim(request.getParameter("action"));

        try {
            if ("CLIENTE".equals(rol)) {
                switch (action) {
                    case "crear":             crearSolicitud(request, session, idUsuario); break;
                    case "agregarDocumento":  agregarDocumento(request, session, idUsuario); break;
                    case "eliminarDocumento": eliminarDocumento(request, session, idUsuario); break;
                    case "cancelar":          cancelar(request, session, idUsuario); break;
                    default: session.setAttribute("mensajeError", "Accion no reconocida.");
                }
            } else if ("INMOBILIARIA".equals(rol)) {
                if ("cambiarEstado".equals(action)) {
                    cambiarEstado(request, session, idUsuario);
                } else {
                    session.setAttribute("mensajeError", "Accion no reconocida.");
                }
            } else {
                request.setAttribute("rutaSolicitada", request.getServletPath());
                request.setAttribute("rolActual", rol);
                request.getRequestDispatcher("/acceso_denegado.jsp").forward(request, response);
                return;
            }

        } catch (SQLException e) {
            session.setAttribute("mensajeError",
                    "No se pudo procesar la operacion por un error de base de datos.");
        }

        response.sendRedirect(request.getContextPath() + "/SolicitudCompraServlet");
    }

    // ====================================================
    // ACCIONES CLIENTE
    // ====================================================

    private void crearSolicitud(HttpServletRequest request, HttpSession session, int idUsuario)
            throws SQLException {

        int idPropiedad = parseEntero(request.getParameter("idPropiedad"), 0);
        String tipo = trim(request.getParameter("tipo")).toUpperCase();
        BigDecimal monto = parseDecimal(request.getParameter("montoOferta"));
        String mensaje = trim(request.getParameter("mensaje"));

        if (idPropiedad <= 0 || !TIPOS_VALIDOS.contains(tipo)) {
            session.setAttribute("mensajeError", "Datos de la solicitud invalidos.");
            return;
        }

        Propiedad p = propiedadDAO.obtenerPorId(idPropiedad);
        if (p == null || !p.isEstadoLogico()) {
            session.setAttribute("mensajeError", "La propiedad no existe o no esta disponible.");
            return;
        }

        if (mensaje.length() > 500) {
            mensaje = mensaje.substring(0, 500);
        }

        Solicitud s = new Solicitud();
        s.setIdPropiedad(idPropiedad);
        s.setIdCliente(idUsuario);
        s.setTipo(tipo);
        s.setMontoOferta(monto);
        s.setMensaje(mensaje);

        int id = solicitudDAO.crearSolicitud(s);
        session.setAttribute(id > 0 ? "mensajeExito" : "mensajeError",
                id > 0 ? "Solicitud de " + tipo.toLowerCase() + " radicada correctamente. "
                       + "Ahora puedes adjuntar tus documentos."
                     : "No se pudo radicar la solicitud. Intente nuevamente.");
    }

    private void agregarDocumento(HttpServletRequest request, HttpSession session, int idUsuario)
            throws SQLException {

        int idSolicitud = parseEntero(request.getParameter("idSolicitud"), 0);
        String tipo = trim(request.getParameter("tipoDocumento"));
        String nombre = trim(request.getParameter("nombreDocumento"));
        String url = trim(request.getParameter("urlDocumento"));

        Solicitud s = solicitudDAO.obtenerPorId(idSolicitud);

        if (s == null || s.getIdCliente() != idUsuario) {
            session.setAttribute("mensajeError", "Solicitud no encontrada o sin permisos.");
            return;
        }
        if (nombre.isEmpty() || url.isEmpty()) {
            session.setAttribute("mensajeError", "El nombre y la URL del documento son obligatorios.");
            return;
        }
        if ("APROBADA".equals(s.getEstado()) || "RECHAZADA".equals(s.getEstado())) {
            session.setAttribute("mensajeError",
                    "La solicitud ya fue resuelta; no se pueden agregar documentos.");
            return;
        }

        DocumentoSolicitud d = new DocumentoSolicitud();
        d.setIdSolicitud(idSolicitud);
        d.setTipo(tipo);
        d.setNombre(nombre.length() > 150 ? nombre.substring(0, 150) : nombre);
        d.setUrlDocumento(url.length() > 500 ? url.substring(0, 500) : url);

        boolean ok = solicitudDAO.agregarDocumento(d);
        session.setAttribute(ok ? "mensajeExito" : "mensajeError",
                ok ? "Documento radicado correctamente."
                   : "No se pudo radicar el documento.");
    }

    private void eliminarDocumento(HttpServletRequest request, HttpSession session, int idUsuario)
            throws SQLException {

        int idDocumento = parseEntero(request.getParameter("idDocumento"), 0);
        DocumentoSolicitud d = solicitudDAO.obtenerDocumento(idDocumento);

        if (d == null) {
            session.setAttribute("mensajeError", "El documento no existe.");
            return;
        }

        Solicitud s = solicitudDAO.obtenerPorId(d.getIdSolicitud());
        if (s == null || s.getIdCliente() != idUsuario) {
            session.setAttribute("mensajeError", "No tiene permisos para eliminar este documento.");
            return;
        }

        boolean ok = solicitudDAO.eliminarDocumento(idDocumento);
        session.setAttribute(ok ? "mensajeExito" : "mensajeError",
                ok ? "Documento eliminado." : "No se pudo eliminar el documento.");
    }

    private void cancelar(HttpServletRequest request, HttpSession session, int idUsuario)
            throws SQLException {

        int idSolicitud = parseEntero(request.getParameter("idSolicitud"), 0);
        Solicitud s = solicitudDAO.obtenerPorId(idSolicitud);

        if (s == null || s.getIdCliente() != idUsuario) {
            session.setAttribute("mensajeError", "Solicitud no encontrada o sin permisos.");
            return;
        }

        boolean ok = solicitudDAO.cambiarEstado(idSolicitud, "CANCELADA", "Cancelada por el cliente.");
        session.setAttribute(ok ? "mensajeExito" : "mensajeError",
                ok ? "Solicitud cancelada." : "No se pudo cancelar la solicitud.");
    }

    // ====================================================
    // ACCIONES INMOBILIARIA
    // ====================================================

    private void cambiarEstado(HttpServletRequest request, HttpSession session, int idUsuario)
            throws SQLException {

        int idSolicitud = parseEntero(request.getParameter("idSolicitud"), 0);
        String estado = trim(request.getParameter("estado")).toUpperCase();
        String observacion = trim(request.getParameter("observacion"));

        if (!ESTADOS_VALIDOS.contains(estado)) {
            session.setAttribute("mensajeError", "Estado invalido.");
            return;
        }

        Solicitud s = solicitudDAO.obtenerPorId(idSolicitud);
        if (s == null || s.getIdInmobiliaria() != idUsuario) {
            session.setAttribute("mensajeError", "Solicitud no encontrada o sin permisos.");
            return;
        }

        if (observacion.length() > 500) {
            observacion = observacion.substring(0, 500);
        }

        boolean ok = solicitudDAO.cambiarEstado(idSolicitud, estado, observacion);
        session.setAttribute(ok ? "mensajeExito" : "mensajeError",
                ok ? "Solicitud marcada como " + estado + "."
                   : "No se pudo actualizar la solicitud.");
    }

    // ====================================================
    // UTILIDADES
    // ====================================================

    private Map<Integer, List<DocumentoSolicitud>> cargarDocumentos(List<Solicitud> solicitudes)
            throws SQLException {
        Map<Integer, List<DocumentoSolicitud>> mapa = new HashMap<>();
        for (Solicitud s : solicitudes) {
            mapa.put(s.getIdSolicitud(), solicitudDAO.listarDocumentos(s.getIdSolicitud()));
        }
        return mapa;
    }

    private BigDecimal parseDecimal(String valor) {
        if (valor == null || valor.trim().isEmpty()) {
            return null;
        }
        try {
            return new BigDecimal(valor.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private int parseEntero(String valor, int porDefecto) {
        try {
            return Integer.parseInt(valor.trim());
        } catch (Exception e) {
            return porDefecto;
        }
    }

    private String trim(String valor) {
        return valor != null ? valor.trim() : "";
    }
}
