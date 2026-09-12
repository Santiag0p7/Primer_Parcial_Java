package com.inmobiliaria.controller;

import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.model.Propiedad;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

/**
 * Controlador del CRUD de Propiedades (Sprint 2 - Item 1).
 * Mapeado a /PropiedadServlet.
 *
 * Acciones soportadas mediante el parametro 'action':
 *   list   -> lista las propiedades de la inmobiliaria en sesion
 *   new    -> muestra el formulario vacio
 *   insert -> inserta una nueva propiedad
 *   edit   -> muestra el formulario con los datos de la propiedad
 *   update -> actualiza una propiedad existente
 *   delete -> BAJA LOGICA (no borra fisicamente)
 *
 * La restriccion UNIQUE de matricula_inmobiliaria se captura como
 * SQLException y se reenvia a la vista como alerta amigable.
 */
public class PropiedadServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final PropiedadDAO propiedadDAO = new PropiedadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "list";
        }

        try {
            switch (action) {
                case "new":
                    mostrarFormulario(request, response, null);
                    break;
                case "edit":
                    mostrarEdicion(request, response);
                    break;
                case "delete":
                    ejecutarBajaLogica(request, response);
                    break;
                case "list":
                default:
                    listar(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Error de base de datos al procesar la solicitud.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "insert":
                    insertar(request, response);
                    break;
                case "update":
                    actualizar(request, response);
                    break;
                default:
                    listar(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Error de base de datos al procesar la solicitud.", e);
        }
    }

    // ====================================================
    // ACCIONES
    // ====================================================

    /**
     * Lista las propiedades activas de la inmobiliaria en sesion.
     */
    private void listar(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int idInmobiliaria = obtenerIdInmobiliaria(request);
        List<Propiedad> propiedades = propiedadDAO.listarPorInmobiliaria(idInmobiliaria);

        request.setAttribute("propiedades", propiedades);
        request.setAttribute("tituloPagina", "Mis Propiedades - Inmobiliaria UTS");
        request.getRequestDispatcher("/dashboard/agente/mis_propiedades.jsp")
               .forward(request, response);
    }

    /**
     * Muestra el formulario de creacion (propiedad == null) o edicion.
     * Carga los catalogos de tipos y ciudades para los selectores.
     */
    private void mostrarFormulario(HttpServletRequest request, HttpServletResponse response,
                                   Propiedad propiedad)
            throws SQLException, ServletException, IOException {

        request.setAttribute("propiedad", propiedad);
        request.setAttribute("tipos", propiedadDAO.listarTipos());
        request.setAttribute("ciudades", propiedadDAO.listarCiudades());
        request.setAttribute("tituloPagina", "Propiedad - Inmobiliaria UTS");
        request.getRequestDispatcher("/dashboard/agente/formulario_propiedad.jsp")
               .forward(request, response);
    }

    /**
     * Carga una propiedad existente y muestra el formulario de edicion.
     */
    private void mostrarEdicion(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = parseEntero(request.getParameter("id"), 0);

        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/PropiedadServlet?action=list");
            return;
        }

        Propiedad propiedad = propiedadDAO.obtenerPorId(id);

        if (propiedad == null) {
            request.getSession().setAttribute("mensajeError",
                    "La propiedad solicitada no existe.");
            response.sendRedirect(request.getContextPath() + "/PropiedadServlet?action=list");
            return;
        }

        mostrarFormulario(request, response, propiedad);
    }

    /**
     * Inserta una nueva propiedad capturando el error UNIQUE.
     */
    private void insertar(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        Propiedad p = construirDesdeRequest(request);

        try {
            boolean ok = propiedadDAO.insertar(p);

            if (ok) {
                request.getSession().setAttribute("mensajeExito",
                        "Propiedad registrada correctamente.");
                response.sendRedirect(request.getContextPath() + "/PropiedadServlet?action=list");
                return;
            }

            request.setAttribute("error", "No se pudo registrar la propiedad. Intente de nuevo.");
            mostrarFormulario(request, response, p);

        } catch (SQLException e) {
            request.setAttribute("error", mensajeUnico(e));
            mostrarFormulario(request, response, p);
        }
    }

    /**
     * Actualiza una propiedad capturando el error UNIQUE.
     */
    private void actualizar(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = parseEntero(request.getParameter("idPropiedad"), 0);

        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/PropiedadServlet?action=list");
            return;
        }

        Propiedad p = construirDesdeRequest(request);
        p.setIdPropiedad(id);

        try {
            boolean ok = propiedadDAO.actualizar(p);

            if (ok) {
                request.getSession().setAttribute("mensajeExito",
                        "Propiedad actualizada correctamente.");
                response.sendRedirect(request.getContextPath() + "/PropiedadServlet?action=list");
                return;
            }

            request.setAttribute("error", "No se pudo actualizar la propiedad. Intente de nuevo.");
            mostrarFormulario(request, response, p);

        } catch (SQLException e) {
            request.setAttribute("error", mensajeUnico(e));
            mostrarFormulario(request, response, p);
        }
    }

    /**
     * REQUISITO DEL PARCIAL: la accion delete ejecuta BAJA LOGICA.
     */
    private void ejecutarBajaLogica(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int id = parseEntero(request.getParameter("id"), 0);

        if (id > 0) {
            boolean ok = propiedadDAO.bajaLogica(id);
            request.getSession().setAttribute(
                    ok ? "mensajeExito" : "mensajeError",
                    ok ? "Propiedad desactivada correctamente."
                       : "No se pudo desactivar la propiedad.");
        }

        response.sendRedirect(request.getContextPath() + "/PropiedadServlet?action=list");
    }

    // ====================================================
    // UTILIDADES
    // ====================================================

    /**
     * Construye un objeto Propiedad a partir de los parametros del formulario.
     * El idInmobiliaria SIEMPRE se toma de la sesion para evitar manipulacion.
     */
    private Propiedad construirDesdeRequest(HttpServletRequest request) {
        Propiedad p = new Propiedad();

        p.setMatriculaInmobiliaria(trim(request.getParameter("matriculaInmobiliaria")));
        p.setTitulo(trim(request.getParameter("titulo")));
        p.setDescripcion(trim(request.getParameter("descripcion")));
        p.setPrecio(parseDecimal(request.getParameter("precio")));
        p.setHabitaciones(parseEntero(request.getParameter("habitaciones"), 0));
        p.setBanos(parseEntero(request.getParameter("banos"), 0));
        p.setAreaM2(parseDecimal(request.getParameter("areaM2")));
        p.setDireccion(trim(request.getParameter("direccion")));
        p.setIdTipo(parseEntero(request.getParameter("idTipo"), 0));
        p.setIdCiudad(parseEntero(request.getParameter("idCiudad"), 0));
        p.setIdInmobiliaria(obtenerIdInmobiliaria(request));

        return p;
    }

    /**
     * Obtiene el ID de la inmobiliaria desde la sesion del usuario autenticado.
     */
    private int obtenerIdInmobiliaria(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("idUsuario") != null) {
            return (Integer) session.getAttribute("idUsuario");
        }
        return 0;
    }

    /**
     * Devuelve un mensaje amigable segun el error SQL.
     * Traduce la violacion UNIQUE de matricula_inmobiliaria.
     */
    private String mensajeUnico(SQLException e) {
        String mensaje = e.getMessage();
        if (mensaje != null && mensaje.toLowerCase().contains("matricula")) {
            return "La matricula inmobiliaria ya se encuentra registrada. "
                 + "Verifique el numero e intente nuevamente.";
        }
        return "No se pudo guardar la propiedad. Verifique los datos e intente de nuevo.";
    }

    private String trim(String valor) {
        return valor != null ? valor.trim() : "";
    }

    private int parseEntero(String valor, int porDefecto) {
        try {
            return Integer.parseInt(valor.trim());
        } catch (Exception e) {
            return porDefecto;
        }
    }

    private BigDecimal parseDecimal(String valor) {
        if (valor == null || valor.trim().isEmpty()) {
            return BigDecimal.ZERO;
        }
        try {
            return new BigDecimal(valor.trim());
        } catch (NumberFormatException e) {
            return BigDecimal.ZERO;
        }
    }
}
