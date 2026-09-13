package com.inmobiliaria.controller;

import com.inmobiliaria.dao.PerfilDAO;
import com.inmobiliaria.model.Perfil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Controlador de la gestion del perfil del usuario (relacion 1:1).
 * Mapeado a /PerfilServlet.
 *
 * doGet  -> Recupera el usuario de la sesion, carga su perfil desde la
 *           base de datos y reenvia a /dashboard/mi_perfil.jsp.
 * doPost -> Procesa el formulario de actualizacion, valida los campos
 *           obligatorios y persiste los cambios. En caso exitoso redirige
 *           con el parametro 'msg=perfil_actualizado'.
 *
 * El id del usuario SIEMPRE se toma de la sesion para impedir que un
 * usuario modifique el perfil de otra cuenta.
 */
public class PerfilServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final PerfilDAO perfilDAO = new PerfilDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idUsuario = obtenerIdUsuario(request);

        if (idUsuario <= 0) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        Perfil perfil = perfilDAO.obtenerPorIdUsuario(idUsuario);
        request.setAttribute("perfil", perfil);

        // Mensaje de exito tras una actualizacion (patron Post/Redirect/Get)
        if ("perfil_actualizado".equals(request.getParameter("msg"))) {
            request.setAttribute("exito", "Perfil actualizado correctamente.");
        }

        request.setAttribute("tituloPagina", "Mi Perfil - Inmobiliaria UTS");
        request.getRequestDispatcher("/dashboard/mi_perfil.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idUsuario = obtenerIdUsuario(request);

        if (idUsuario <= 0) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // 1. Obtener y limpiar parametros del formulario
        String nombres = trim(request.getParameter("nombres"));
        String apellidos = trim(request.getParameter("apellidos"));
        String documento = trim(request.getParameter("documento"));
        String telefono = trim(request.getParameter("telefono"));
        String direccion = trim(request.getParameter("direccion"));

        // 2. Construir el Perfil con el ID de sesion (nunca desde el formulario)
        Perfil perfil = new Perfil();
        perfil.setIdUsuario(idUsuario);
        perfil.setNombres(nombres);
        perfil.setApellidos(apellidos);
        perfil.setDocumento(documento);
        perfil.setTelefono(telefono);
        perfil.setDireccion(direccion);

        // 3. Validacion de campos obligatorios
        if (nombres.isEmpty() || apellidos.isEmpty() || documento.isEmpty()) {
            request.setAttribute("error", "Los campos Nombres, Apellidos y Documento son obligatorios.");
            request.setAttribute("perfil", perfil);
            request.setAttribute("tituloPagina", "Mi Perfil - Inmobiliaria UTS");
            request.getRequestDispatcher("/dashboard/mi_perfil.jsp")
                   .forward(request, response);
            return;
        }

        // 4. Persistir cambios (UPDATE si existe, INSERT si no)
        try {
            boolean ok = perfilDAO.guardarOActualizar(perfil);

            if (ok) {
                response.sendRedirect(request.getContextPath()
                        + "/PerfilServlet?msg=perfil_actualizado");
            } else {
                request.setAttribute("error", "No se pudo actualizar el perfil. Intente de nuevo.");
                request.setAttribute("perfil", perfil);
                request.setAttribute("tituloPagina", "Mi Perfil - Inmobiliaria UTS");
                request.getRequestDispatcher("/dashboard/mi_perfil.jsp")
                       .forward(request, response);
            }

        } catch (SQLException e) {
            // Violacion UNIQUE de documento (pertenece a otro usuario)
            String mensaje = e.getMessage();
            if (mensaje != null && mensaje.toLowerCase().contains("documento")) {
                request.setAttribute("error",
                        "El documento ya se encuentra registrado en otra cuenta.");
            } else {
                request.setAttribute("error",
                        "No se pudo guardar el perfil. Verifique los datos e intente de nuevo.");
            }
            request.setAttribute("perfil", perfil);
            request.setAttribute("tituloPagina", "Mi Perfil - Inmobiliaria UTS");
            request.getRequestDispatcher("/dashboard/mi_perfil.jsp")
                   .forward(request, response);
        }
    }

    /**
     * Obtiene el ID del usuario autenticado desde la sesion.
     */
    private int obtenerIdUsuario(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("idUsuario") != null) {
            return (Integer) session.getAttribute("idUsuario");
        }
        return 0;
    }

    private String trim(String valor) {
        return valor != null ? valor.trim() : "";
    }
}
