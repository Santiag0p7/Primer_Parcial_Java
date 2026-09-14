package com.inmobiliaria.controller;

import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.model.Propiedad;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Controlador del panel de administracion de propiedades.
 * Mapeado a /AdminPropiedadServlet. Acceso exclusivo del rol ADMINISTRADOR.
 *
 * doGet : lista TODAS las propiedades (activas e inactivas) con su inmobiliaria.
 * doPost: activa o desactiva (baja logica) una propiedad (action=cambiarEstado).
 */
public class AdminPropiedadServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final PropiedadDAO propiedadDAO = new PropiedadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!verificarAdmin(request, response)) {
            return;
        }

        String filtro = normalizarFiltro(request.getParameter("estado"));

        try {
            List<Propiedad> propiedades = propiedadDAO.listarTodasAdmin(filtro);
            request.setAttribute("propiedades", propiedades);
        } catch (SQLException e) {
            request.setAttribute("error", "No se pudo cargar la lista de propiedades.");
        }

        request.setAttribute("filtroEstado", filtro);
        request.setAttribute("tituloPagina", "Gestion de Propiedades - JSGE In-Mobiliaria");
        request.getRequestDispatcher("/dashboard/admin/gestion_propiedades.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!verificarAdmin(request, response)) {
            return;
        }

        HttpSession session = request.getSession(false);
        String action = trim(request.getParameter("action"));

        if ("cambiarEstado".equals(action)) {
            int idPropiedad = parseEntero(request.getParameter("idPropiedad"), 0);
            boolean activo = "true".equals(request.getParameter("activo"));

            if (idPropiedad <= 0) {
                session.setAttribute("mensajeError", "Propiedad invalida.");
            } else {
                try {
                    boolean ok = propiedadDAO.cambiarEstadoLogico(idPropiedad, activo);
                    session.setAttribute(ok ? "mensajeExito" : "mensajeError",
                            ok ? (activo ? "Propiedad activada correctamente."
                                         : "Propiedad desactivada correctamente.")
                               : "No se pudo cambiar el estado de la propiedad.");
                } catch (SQLException e) {
                    session.setAttribute("mensajeError",
                            "Ocurrio un error de base de datos al cambiar el estado.");
                }
            }
        } else {
            session.setAttribute("mensajeError", "Accion no reconocida.");
        }

        String filtro = normalizarFiltro(request.getParameter("estado"));
        response.sendRedirect(request.getContextPath()
                + "/AdminPropiedadServlet?estado=" + filtro);
    }

    // ====================================================
    // UTILIDADES
    // ====================================================

    /**
     * Verifica que la peticion provenga de un ADMINISTRADOR autenticado.
     */
    private boolean verificarAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idUsuario") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return false;
        }

        if (!"ADMINISTRADOR".equals(session.getAttribute("rol"))) {
            request.setAttribute("rutaSolicitada", request.getServletPath());
            request.setAttribute("rolActual", session.getAttribute("rol"));
            request.getRequestDispatcher("/acceso_denegado.jsp").forward(request, response);
            return false;
        }
        return true;
    }

    private String normalizarFiltro(String estado) {
        if ("activas".equals(estado)) return "activas";
        if ("inactivas".equals(estado)) return "inactivas";
        return "todas";
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
