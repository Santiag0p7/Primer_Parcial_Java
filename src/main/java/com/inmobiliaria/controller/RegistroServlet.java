package com.inmobiliaria.controller;

import com.inmobiliaria.dao.UsuarioDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Servlet que procesa el registro de nuevos usuarios (clientes).
 * Cifra la contrasena con BCrypt antes de guardarla en la base de datos.
 * Captura errores de duplicados (correo/documento UNIQUE) y muestra
 * mensajes amigables al usuario.
 */
public class RegistroServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Mostrar formulario de registro
        request.getRequestDispatcher("/registro.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Obtener y validar parametros del formulario
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String documento = request.getParameter("documento");

        // Trim para evitar espacios en blanco
        if (correo != null) correo = correo.trim();
        if (nombres != null) nombres = nombres.trim();
        if (apellidos != null) apellidos = apellidos.trim();
        if (documento != null) documento = documento.trim();

        // 2. Validacion basica de campos obligatorios
        if (correo == null || correo.isEmpty()
                || password == null || password.isEmpty()
                || nombres == null || nombres.isEmpty()
                || apellidos == null || apellidos.isEmpty()
                || documento == null || documento.isEmpty()) {

            request.setAttribute("error", "Todos los campos son obligatorios.");
            request.setAttribute("correo", correo);
            request.setAttribute("nombres", nombres);
            request.setAttribute("apellidos", apellidos);
            request.setAttribute("documento", documento);
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }

        // 3. Validar formato de correo
        if (!correo.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            request.setAttribute("error", "El formato del correo electronico no es valido.");
            request.setAttribute("correo", correo);
            request.setAttribute("nombres", nombres);
            request.setAttribute("apellidos", apellidos);
            request.setAttribute("documento", documento);
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }

        // 4. Validar longitud minima de contrasena
        if (password.length() < 6) {
            request.setAttribute("error", "La contrasena debe tener al menos 6 caracteres.");
            request.setAttribute("correo", correo);
            request.setAttribute("nombres", nombres);
            request.setAttribute("apellidos", apellidos);
            request.setAttribute("documento", documento);
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
            return;
        }

        // 5. Cifrar contrasena con BCrypt (10 rounds de salt)
        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt(10));

        // 6. Intentar registrar en la base de datos
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        try {
            boolean registrado = usuarioDAO.registrarCliente(
                    correo, passwordHash, nombres, apellidos, documento);

            if (registrado) {
                // Exito: redirigir al login con mensaje de confirmacion
                request.getSession().setAttribute("exitoRegistro",
                        "Registro exitoso. Ahora puedes iniciar sesion con tu correo.");
                response.sendRedirect(request.getContextPath() + "/LoginServlet");
            } else {
                // Error general de insercion
                request.setAttribute("error", "No se pudo completar el registro. Intente de nuevo.");
                request.setAttribute("correo", correo);
                request.setAttribute("nombres", nombres);
                request.setAttribute("apellidos", apellidos);
                request.setAttribute("documento", documento);
                request.getRequestDispatcher("/registro.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            // 7. Capturar errores de integridad UNIQUE (correo o documento duplicado)
            String mensaje = e.getMessage();
            if (mensaje != null && mensaje.contains("correo")) {
                request.setAttribute("error",
                        "El correo electronico ya se encuentra registrado. Intente con otro correo.");
            } else if (mensaje != null && mensaje.contains("documento")) {
                request.setAttribute("error",
                        "El documento ya se encuentra registrado. Verifique su numero de documento.");
            } else {
                request.setAttribute("error",
                        "El correo o documento ya se encuentra registrado.");
            }
            request.setAttribute("correo", correo);
            request.setAttribute("nombres", nombres);
            request.setAttribute("apellidos", apellidos);
            request.setAttribute("documento", documento);
            request.getRequestDispatcher("/registro.jsp").forward(request, response);
        }
    }
}
