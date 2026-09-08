package com.inmobiliaria.controller;

import com.inmobiliaria.dao.UsuarioDAO;
import com.inmobiliaria.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Servlet que procesa el inicio de sesion de usuarios.
 * Verifica la contrasena cifrada con BCrypt, crea la sesion
 * y redirige dinamicamente segun el rol del usuario:
 *   ADMINISTRADOR  -> /dashboard/admin/index.jsp
 *   INMOBILIARIA   -> /dashboard/agente/index.jsp
 *   CLIENTE        -> /dashboard/cliente/index.jsp
 */
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Mostrar formulario de login
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String correo = request.getParameter("correo");
        String password = request.getParameter("password");

        if (correo != null) correo = correo.trim();

        // Validacion basica
        if (correo == null || correo.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Ingrese su correo y contrasena.");
            request.setAttribute("correo", correo);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Buscar usuario en la base de datos
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        Usuario usuario = usuarioDAO.obtenerPorCorreo(correo);

        // Verificar que el usuario exista y la contrasena sea correcta
        if (usuario == null || !BCrypt.checkpw(password, usuario.getPasswordHash())) {
            request.setAttribute("error", "Correo o contrasena incorrectos.");
            request.setAttribute("correo", correo);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Verificar que el usuario este activo
        if (!usuario.isEstado()) {
            request.setAttribute("error", "Su cuenta esta desactivada. Contacte al administrador.");
            request.setAttribute("correo", correo);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Obtener el rol principal del usuario
        String rol = usuarioDAO.obtenerRolPrincipal(usuario.getIdUsuario());

        if (rol == null) {
            request.setAttribute("error", "Su cuenta no tiene un rol asignado. Contacte al administrador.");
            request.setAttribute("correo", correo);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Crear sesion y guardar datos del usuario
        HttpSession session = request.getSession(true);
        session.setAttribute("idUsuario", usuario.getIdUsuario());
        session.setAttribute("correo", usuario.getCorreo());
        session.setAttribute("rol", rol);
        session.setMaxInactiveInterval(30 * 60); // 30 minutos

        // Redirigir dinamicamente segun el rol
        String contextPath = request.getContextPath();
        switch (rol) {
            case "ADMINISTRADOR":
                response.sendRedirect(contextPath + "/dashboard/admin/index.jsp");
                break;
            case "INMOBILIARIA":
                response.sendRedirect(contextPath + "/dashboard/agente/index.jsp");
                break;
            case "CLIENTE":
                response.sendRedirect(contextPath + "/dashboard/cliente/index.jsp");
                break;
            default:
                response.sendRedirect(contextPath + "/index");
                break;
        }
    }
}
