package com.inmobiliaria.controller;

import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.dao.SolicitudVisitaDAO;
import com.inmobiliaria.model.Propiedad;
import com.inmobiliaria.model.SolicitudVisita;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.Arrays;
import java.util.List;

/**
 * Controlador del Sistema de Solicitud de Citas y Agendamiento
 * (Sprint 3 - Item 1). Mapeado a /SolicitudServlet.
 *
 * doPost: registra una nueva solicitud de visita. Exclusivo del rol CLIENTE.
 * doGet : lista las solicitudes segun el rol en sesion
 *         (CLIENTE -> mis_solicitudes_cliente.jsp,
 *          INMOBILIARIA -> gestion_solicitudes_agente.jsp) y procesa
 *         la accion action=updateStatus para cambiar el estado.
 */
public class SolicitudServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final List<String> ESTADOS_VALIDOS =
            Arrays.asList("PENDIENTE", "CONFIRMADA", "CANCELADA", "REALIZADA");

    private final SolicitudVisitaDAO solicitudDAO = new SolicitudVisitaDAO();
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
        String action = request.getParameter("action");

        try {
            if ("updateStatus".equals(action)) {
                actualizarEstado(request, response, session, rol, idUsuario);
                return;
            }

            if ("CLIENTE".equals(rol)) {
                request.setAttribute("solicitudes", solicitudDAO.listarPorCliente(idUsuario));
                request.setAttribute("tituloPagina", "Mis Solicitudes - Inmobiliaria UTS");
                request.getRequestDispatcher("/dashboard/cliente/mis_solicitudes_cliente.jsp")
                       .forward(request, response);

            } else if ("INMOBILIARIA".equals(rol)) {
                request.setAttribute("solicitudes", solicitudDAO.listarPorInmobiliaria(idUsuario));
                request.setAttribute("tituloPagina", "Solicitudes Recibidas - Inmobiliaria UTS");
                request.getRequestDispatcher("/dashboard/agente/gestion_solicitudes_agente.jsp")
                       .forward(request, response);

            } else {
                // Otros roles (ADMINISTRADOR) vuelven a su panel
                response.sendRedirect(request.getContextPath() + "/dashboard/admin/index.jsp");
            }

        } catch (SQLException e) {
            throw new ServletException("Error de base de datos al procesar las solicitudes.", e);
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

        // Solo un CLIENTE puede agendar visitas
        if (!"CLIENTE".equals(session.getAttribute("rol"))) {
            request.setAttribute("rutaSolicitada", request.getServletPath());
            request.setAttribute("rolActual", session.getAttribute("rol"));
            request.getRequestDispatcher("/acceso_denegado.jsp").forward(request, response);
            return;
        }

        int idCliente = (Integer) session.getAttribute("idUsuario");
        int idPropiedad = parseEntero(request.getParameter("idPropiedad"), 0);
        String fechaStr = trim(request.getParameter("fechaVisita"));
        String horaStr = trim(request.getParameter("horaVisita"));
        String comentario = trim(request.getParameter("comentario"));

        try {
            Propiedad propiedad = propiedadDAO.obtenerPorId(idPropiedad);
            if (propiedad == null || !propiedad.isEstadoLogico()) {
                session.setAttribute("mensajeError",
                        "La propiedad no existe o no esta disponible para agendar.");
                response.sendRedirect(request.getContextPath() + "/buscar");
                return;
            }

            LocalDate fecha = parseFecha(fechaStr);
            LocalTime hora = parseHora(horaStr);

            if (fecha == null || hora == null) {
                session.setAttribute("mensajeError",
                        "Debe indicar una fecha y una hora validas para la visita.");
                response.sendRedirect(volverADetalle(request, idPropiedad));
                return;
            }

            if (fecha.isBefore(LocalDate.now())) {
                session.setAttribute("mensajeError",
                        "La fecha de la visita no puede ser anterior a hoy.");
                response.sendRedirect(volverADetalle(request, idPropiedad));
                return;
            }

            if (comentario.length() > 500) {
                comentario = comentario.substring(0, 500);
            }

            SolicitudVisita sol = new SolicitudVisita();
            sol.setIdPropiedad(idPropiedad);
            sol.setIdCliente(idCliente);
            sol.setFechaVisita(fecha);
            sol.setHoraVisita(hora);
            sol.setComentario(comentario);
            sol.setEstado("PENDIENTE");

            boolean ok = solicitudDAO.crearSolicitud(sol);
            session.setAttribute(ok ? "mensajeExito" : "mensajeError",
                    ok ? "Solicitud de visita enviada correctamente. La inmobiliaria la revisara pronto."
                       : "No se pudo registrar la solicitud. Intente nuevamente.");

        } catch (SQLException e) {
            session.setAttribute("mensajeError",
                    "No se pudo registrar la solicitud por un error de base de datos.");
        }

        response.sendRedirect(request.getContextPath() + "/SolicitudServlet");
    }

    // ====================================================
    // ACCIONES
    // ====================================================

    /**
     * Procesa action=updateStatus validando permisos por rol:
     *  - INMOBILIARIA: solo sobre solicitudes de sus propias propiedades.
     *  - CLIENTE     : solo puede CANCELAR sus propias solicitudes.
     */
    private void actualizarEstado(HttpServletRequest request, HttpServletResponse response,
                                  HttpSession session, String rol, int idUsuario)
            throws SQLException, IOException {

        int idSolicitud = parseEntero(request.getParameter("id"), 0);
        String nuevoEstado = trim(request.getParameter("estado")).toUpperCase();

        if (idSolicitud <= 0 || !ESTADOS_VALIDOS.contains(nuevoEstado)) {
            session.setAttribute("mensajeError", "Solicitud o estado invalido.");
            response.sendRedirect(request.getContextPath() + "/SolicitudServlet");
            return;
        }

        SolicitudVisita sol = solicitudDAO.obtenerPorId(idSolicitud);

        if (sol == null) {
            session.setAttribute("mensajeError", "La solicitud no existe.");
            response.sendRedirect(request.getContextPath() + "/SolicitudServlet");
            return;
        }

        boolean autorizado = false;
        if ("INMOBILIARIA".equals(rol)) {
            autorizado = sol.getIdInmobiliaria() == idUsuario;
        } else if ("CLIENTE".equals(rol)) {
            autorizado = sol.getIdCliente() == idUsuario && "CANCELADA".equals(nuevoEstado);
        }

        if (!autorizado) {
            session.setAttribute("mensajeError",
                    "No tiene permisos para cambiar el estado de esta solicitud.");
            response.sendRedirect(request.getContextPath() + "/SolicitudServlet");
            return;
        }

        boolean ok = solicitudDAO.cambiarEstado(idSolicitud, nuevoEstado);
        session.setAttribute(ok ? "mensajeExito" : "mensajeError",
                ok ? "Estado de la solicitud actualizado a " + nuevoEstado + "."
                   : "No se pudo actualizar el estado de la solicitud.");

        response.sendRedirect(request.getContextPath() + "/SolicitudServlet");
    }

    // ====================================================
    // UTILIDADES
    // ====================================================

    private String volverADetalle(HttpServletRequest request, int idPropiedad) {
        return request.getContextPath() + "/propiedad?id=" + idPropiedad;
    }

    private LocalDate parseFecha(String valor) {
        if (valor == null || valor.isEmpty()) {
            return null;
        }
        try {
            return LocalDate.parse(valor);
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    private LocalTime parseHora(String valor) {
        if (valor == null || valor.isEmpty()) {
            return null;
        }
        try {
            return LocalTime.parse(valor);
        } catch (DateTimeParseException e) {
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
