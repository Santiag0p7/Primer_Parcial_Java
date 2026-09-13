package com.inmobiliaria.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filtro de autenticacion y control de acceso por rol.
 * Protege todas las rutas bajo /dashboard/*.
 *
 * Reglas de acceso:
 *   /dashboard/admin/*     -> Solo usuarios con rol ADMINISTRADOR
 *   /dashboard/agente/*    -> Solo usuarios con rol INMOBILIARIA
 *   /dashboard/cliente/*   -> Solo usuarios con rol CLIENTE
 *
 * Si no hay sesion activa, redirige a login.jsp.
 * Si el rol no corresponde a la ruta, redirige a acceso_denegado.jsp.
 */
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inicializacion si es necesaria
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        // Obtener la ruta solicitada (ej: /dashboard/admin/index.jsp)
        String ruta = request.getServletPath();

        // Verificar que exista una sesion activa
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idUsuario") == null) {
            // No hay sesion -> redirigir al login
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // Obtener el rol del usuario en sesion
        String rol = (String) session.getAttribute("rol");

        if (rol == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // Verificar si la ruta es compatible con el rol
        boolean autorizado = false;

        // Vista de perfil compartida por todos los roles autenticados
        if (ruta.equals("/dashboard/mi_perfil.jsp")) {
            autorizado = true;
        } else if (ruta.startsWith("/dashboard/admin")) {
            autorizado = "ADMINISTRADOR".equals(rol);
        } else if (ruta.startsWith("/dashboard/agente")) {
            autorizado = "INMOBILIARIA".equals(rol);
        } else if (ruta.startsWith("/dashboard/cliente")) {
            autorizado = "CLIENTE".equals(rol);
        }

        if (autorizado) {
            // Continuar con el procesamiento normal
            chain.doFilter(request, response);
        } else {
            // Rol no autorizado para esta ruta
            request.setAttribute("rutaSolicitada", ruta);
            request.setAttribute("rolActual", rol);
            request.getRequestDispatcher("/acceso_denegado.jsp").forward(request, response);
        }
    }

    @Override
    public void destroy() {
        // Limpieza si es necesaria
    }
}
