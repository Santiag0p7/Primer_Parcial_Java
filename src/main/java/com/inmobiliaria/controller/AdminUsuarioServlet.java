package com.inmobiliaria.controller;

import com.inmobiliaria.dao.UsuarioDAO;
import com.inmobiliaria.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Controlador de la Gestion de Usuarios (Sprint 3 - Item 2).
 * Mapeado a /AdminUsuarioServlet. Acceso exclusivo del rol ADMINISTRADOR.
 *
 * doGet : lista todos los usuarios (con filtro opcional por rol).
 * doPost: cambia el rol (action=cambiarRol) o bloquea/activa la cuenta
 *         (action=cambiarEstado).
 */
public class AdminUsuarioServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!verificarAdmin(request, response)) {
            return;
        }

        String filtroRol = trim(request.getParameter("rol"));

        try {
            List<Usuario> usuarios = usuarioDAO.listarTodos();

            if (!filtroRol.isEmpty()) {
                int idRol = parseEntero(filtroRol, 0);
                if (idRol > 0) {
                    List<Usuario> filtrados = new ArrayList<>();
                    for (Usuario u : usuarios) {
                        if (u.getIdRol() == idRol) {
                            filtrados.add(u);
                        }
                    }
                    usuarios = filtrados;
                }
            }

            request.setAttribute("usuarios", usuarios);
            request.setAttribute("roles", usuarioDAO.listarRoles());
            request.setAttribute("filtroRol", filtroRol);

        } catch (SQLException e) {
            request.setAttribute("error", "No se pudo cargar la lista de usuarios.");
        }

        request.setAttribute("tituloPagina", "Gestion de Usuarios - Inmobiliaria UTS");
        request.getRequestDispatcher("/dashboard/admin/gestion_usuarios.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!verificarAdmin(request, response)) {
            return;
        }

        HttpSession session = request.getSession(false);
        int idAdmin = (Integer) session.getAttribute("idUsuario");
        String action = trim(request.getParameter("action"));
        int idUsuario = parseEntero(request.getParameter("idUsuario"), 0);

        try {
            if ("cambiarRol".equals(action)) {
                int idRol = parseEntero(request.getParameter("idRol"), 0);

                if (idUsuario <= 0 || idRol <= 0) {
                    session.setAttribute("mensajeError", "Debe indicar un usuario y un rol validos.");
                } else if (idUsuario == idAdmin) {
                    session.setAttribute("mensajeError",
                            "No puede cambiar su propio rol para no perder el acceso de administrador.");
                } else if (usuarioDAO.cambiarRol(idUsuario, idRol)) {
                    session.setAttribute("mensajeExito", "Rol del usuario actualizado correctamente.");
                } else {
                    session.setAttribute("mensajeError", "No se pudo actualizar el rol del usuario.");
                }

            } else if ("cambiarEstado".equals(action)) {
                boolean activo = "true".equals(request.getParameter("activo"));

                if (idUsuario <= 0) {
                    session.setAttribute("mensajeError", "Usuario invalido.");
                } else if (idUsuario == idAdmin) {
                    session.setAttribute("mensajeError",
                            "No puede bloquear su propia cuenta de administrador.");
                } else if (usuarioDAO.cambiarEstadoCuenta(idUsuario, activo)) {
                    session.setAttribute("mensajeExito",
                            activo ? "Cuenta activada correctamente." : "Cuenta bloqueada correctamente.");
                } else {
                    session.setAttribute("mensajeError", "No se pudo cambiar el estado de la cuenta.");
                }

            } else {
                session.setAttribute("mensajeError", "Accion no reconocida.");
            }

        } catch (SQLException e) {
            session.setAttribute("mensajeError",
                    "Ocurrio un error de base de datos al procesar la solicitud.");
        }

        response.sendRedirect(request.getContextPath() + "/AdminUsuarioServlet");
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
