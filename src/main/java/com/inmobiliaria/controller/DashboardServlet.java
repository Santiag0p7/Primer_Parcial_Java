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
 * Controlador del Dashboard con metricas (Sprint 3 - Item 3).
 * Mapeado a /DashboardServlet.
 *
 * Carga las metricas agregadas desde ReporteDAO y las inyecta en el request
 * segun el rol del usuario en sesion, reenviando (forward) al dashboard
 * correspondiente:
 *   ADMINISTRADOR -> /dashboard/admin/index.jsp
 *   INMOBILIARIA  -> /dashboard/agente/index.jsp
 *   CLIENTE       -> /dashboard/cliente/index.jsp
 *
 * El forward NO vuelve a disparar el AuthFilter (mapeado a REQUEST), por lo
 * que no hay redireccion en bucle.
 */
public class DashboardServlet extends HttpServlet {

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

        String rol = (String) session.getAttribute("rol");
        Integer idUsuario = (Integer) session.getAttribute("idUsuario");

        String destino;
        if ("ADMINISTRADOR".equals(rol)) {
            destino = "/dashboard/admin/index.jsp";
            request.setAttribute("tituloPagina", "Panel Administrador - JSGE In-Mobiliaria");
        } else if ("INMOBILIARIA".equals(rol)) {
            destino = "/dashboard/agente/index.jsp";
            request.setAttribute("tituloPagina", "Panel Agente - JSGE In-Mobiliaria");
        } else if ("CLIENTE".equals(rol)) {
            destino = "/dashboard/cliente/index.jsp";
            request.setAttribute("tituloPagina", "Mi Panel - JSGE In-Mobiliaria");
        } else {
            request.setAttribute("rutaSolicitada", request.getServletPath());
            request.setAttribute("rolActual", rol);
            request.getRequestDispatcher("/acceso_denegado.jsp").forward(request, response);
            return;
        }

        try {
            cargarMetricas(request, rol, idUsuario);
        } catch (SQLException e) {
            request.setAttribute("errorMetricas",
                    "No se pudieron cargar las metricas del dashboard.");
        }

        request.getRequestDispatcher(destino).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Inyecta las metricas en el request. Las consultas globales (usuarios,
     * agrupaciones) se reservan al ADMINISTRADOR; la INMOBILIARIA solo ve sus
     * propios contadores para no exponer datos de terceros.
     */
    private void cargarMetricas(HttpServletRequest request, String rol, Integer idUsuario)
            throws SQLException {

        if ("ADMINISTRADOR".equals(rol)) {
            request.setAttribute("totalPropiedadesActivas", reporteDAO.totalPropiedadesActivas());
            request.setAttribute("totalSolicitudesPendientes", reporteDAO.totalSolicitudesPendientes());
            request.setAttribute("totalUsuarios", reporteDAO.totalUsuarios());
            request.setAttribute("metricasPorCiudad", reporteDAO.obtenerMetricasPorCiudad());
            request.setAttribute("metricasPorTipo", reporteDAO.obtenerMetricasPorTipo());

        } else if ("INMOBILIARIA".equals(rol) && idUsuario != null) {
            request.setAttribute("totalPropiedadesActivas",
                    reporteDAO.totalPropiedadesActivasPorInmobiliaria(idUsuario));
            request.setAttribute("totalSolicitudesPendientes",
                    reporteDAO.totalSolicitudesPendientesPorInmobiliaria(idUsuario));
        }
    }
}
