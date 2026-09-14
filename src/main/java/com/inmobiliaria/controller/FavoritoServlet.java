package com.inmobiliaria.controller;

import com.inmobiliaria.dao.FavoritoDAO;
import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.model.Propiedad;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Controlador del modulo de Favoritos (lista de deseos del cliente).
 * Mapeado a /FavoritoServlet. Acceso exclusivo del rol CLIENTE.
 *
 * doGet : lista las propiedades favoritas del cliente.
 * doPost: agrega (action=agregar) o quita (action=eliminar) una propiedad
 *         de los favoritos.
 */
public class FavoritoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final FavoritoDAO favoritoDAO = new FavoritoDAO();
    private final PropiedadDAO propiedadDAO = new PropiedadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = verificarCliente(request, response);
        if (session == null) {
            return;
        }

        int idUsuario = (Integer) session.getAttribute("idUsuario");

        try {
            request.setAttribute("favoritos", favoritoDAO.listarPorUsuario(idUsuario));
        } catch (SQLException e) {
            request.setAttribute("error", "No se pudieron cargar sus favoritos.");
        }

        request.setAttribute("tituloPagina", "Mis Favoritos - JSGE In-Mobiliaria");
        request.getRequestDispatcher("/dashboard/cliente/mis_favoritos.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = verificarCliente(request, response);
        if (session == null) {
            return;
        }

        int idUsuario = (Integer) session.getAttribute("idUsuario");
        int idPropiedad = parseEntero(request.getParameter("idPropiedad"), 0);
        String action = trim(request.getParameter("action"));
        String origen = trim(request.getParameter("origen"));

        try {
            if (idPropiedad <= 0) {
                session.setAttribute("mensajeError", "Propiedad invalida.");

            } else if ("eliminar".equals(action)) {
                boolean ok = favoritoDAO.eliminar(idUsuario, idPropiedad);
                session.setAttribute(ok ? "mensajeExito" : "mensajeError",
                        ok ? "Propiedad eliminada de tus favoritos."
                           : "La propiedad no estaba en tus favoritos.");

            } else {
                // Por defecto: agregar
                Propiedad p = propiedadDAO.obtenerPorId(idPropiedad);
                if (p == null || !p.isEstadoLogico()) {
                    session.setAttribute("mensajeError",
                            "La propiedad no existe o no esta disponible.");
                } else {
                    favoritoDAO.agregar(idUsuario, idPropiedad);
                    session.setAttribute("mensajeExito",
                            "Propiedad agregada a tus favoritos.");
                }
            }

        } catch (SQLException e) {
            session.setAttribute("mensajeError",
                    "No se pudo procesar la operacion por un error de base de datos.");
        }

        // Volver al listado o a la ficha de detalle segun el origen
        if ("lista".equals(origen)) {
            response.sendRedirect(request.getContextPath() + "/FavoritoServlet");
        } else {
            response.sendRedirect(request.getContextPath() + "/propiedad?id=" + idPropiedad);
        }
    }

    // ====================================================
    // UTILIDADES
    // ====================================================

    /**
     * Verifica que la peticion provenga de un CLIENTE autenticado.
     *
     * @return la sesion valida, o null si ya se envio una respuesta de error
     */
    private HttpSession verificarCliente(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idUsuario") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return null;
        }

        if (!"CLIENTE".equals(session.getAttribute("rol"))) {
            request.setAttribute("rutaSolicitada", request.getServletPath());
            request.setAttribute("rolActual", session.getAttribute("rol"));
            request.getRequestDispatcher("/acceso_denegado.jsp").forward(request, response);
            return null;
        }
        return session;
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
