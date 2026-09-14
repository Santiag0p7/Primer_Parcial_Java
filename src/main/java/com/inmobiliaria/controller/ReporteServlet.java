package com.inmobiliaria.controller;

import com.inmobiliaria.dao.ReporteDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Controlador del modulo de reportes del sistema.
 * Mapeado a /ReporteServlet.
 *
 * Acceso restringido al rol ADMINISTRADOR. Carga las consultas obligatorias
 * (INNER JOIN de 4 tablas, LEFT JOIN y GROUP BY + HAVING) y las expone a la
 * vista /dashboard/admin/reportes.jsp.
 */
public class ReporteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ReporteDAO reporteDAO = new ReporteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idUsuario") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        if (!"ADMINISTRADOR".equals(session.getAttribute("rol"))) {
            request.setAttribute("rutaSolicitada", request.getServletPath());
            request.setAttribute("rolActual", session.getAttribute("rol"));
            request.getRequestDispatcher("/acceso_denegado.jsp").forward(request, response);
            return;
        }

        try {
            request.setAttribute("propiedadesConInmobiliaria",
                    reporteDAO.listarPropiedadesConInmobiliaria());
            request.setAttribute("propiedadesSinImagenes",
                    reporteDAO.listarPropiedadesSinImagenes());
            request.setAttribute("conteoPorCiudad",
                    reporteDAO.contarPropiedadesPorCiudad());

        } catch (SQLException e) {
            request.setAttribute("errorReportes",
                    "No se pudieron cargar los reportes. Intente nuevamente.");
        }

        request.setAttribute("tituloPagina", "Reportes - JSGE In-Mobiliaria");
        request.getRequestDispatcher("/dashboard/admin/reportes.jsp")
               .forward(request, response);
    }
}
