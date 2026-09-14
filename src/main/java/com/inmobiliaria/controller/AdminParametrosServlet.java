package com.inmobiliaria.controller;

import com.inmobiliaria.dao.CaracteristicaDAO;
import com.inmobiliaria.dao.CiudadDAO;
import com.inmobiliaria.dao.TipoPropiedadDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Controlador del Mantenimiento de Parametros (Sprint 3 - Item 2).
 * Mapeado a /AdminParametrosServlet. Acceso exclusivo del rol ADMINISTRADOR.
 *
 * Gestiona el CRUD de Ciudad, TipoPropiedad y Caracteristica.
 * Parametros POST:
 *   entidad   -> ciudad | tipo | caracteristica
 *   operacion -> crear | actualizar | eliminar
 *   id        -> id del registro (actualizar/eliminar)
 *   nombre    -> nombre del registro
 *   departamento -> solo para ciudad
 */
public class AdminParametrosServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final CiudadDAO ciudadDAO = new CiudadDAO();
    private final TipoPropiedadDAO tipoPropiedadDAO = new TipoPropiedadDAO();
    private final CaracteristicaDAO caracteristicaDAO = new CaracteristicaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!verificarAdmin(request, response)) {
            return;
        }

        cargarCatalogos(request);
        request.setAttribute("tabActivo", normalizarTab(request.getParameter("tab")));
        request.setAttribute("tituloPagina", "Parametros del Sistema - JSGE In-Mobiliaria");
        request.getRequestDispatcher("/dashboard/admin/gestion_parametros.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!verificarAdmin(request, response)) {
            return;
        }

        HttpSession session = request.getSession(false);
        String entidad = trim(request.getParameter("entidad"));
        String operacion = trim(request.getParameter("operacion"));
        int id = parseEntero(request.getParameter("id"), 0);
        String nombre = trim(request.getParameter("nombre"));
        String departamento = trim(request.getParameter("departamento"));

        try {
            boolean ok = false;
            String etiqueta = etiquetaEntidad(entidad);

            if ("ciudad".equals(entidad)) {
                if ("crear".equals(operacion)) {
                    ok = validar(nombre) && ciudadDAO.insertar(nombre, departamento);
                } else if ("actualizar".equals(operacion)) {
                    ok = id > 0 && validar(nombre) && ciudadDAO.actualizar(id, nombre, departamento);
                } else if ("eliminar".equals(operacion)) {
                    ok = id > 0 && ciudadDAO.eliminar(id);
                }

            } else if ("tipo".equals(entidad)) {
                if ("crear".equals(operacion)) {
                    ok = validar(nombre) && tipoPropiedadDAO.insertar(nombre);
                } else if ("actualizar".equals(operacion)) {
                    ok = id > 0 && validar(nombre) && tipoPropiedadDAO.actualizar(id, nombre);
                } else if ("eliminar".equals(operacion)) {
                    ok = id > 0 && tipoPropiedadDAO.eliminar(id);
                }

            } else if ("caracteristica".equals(entidad)) {
                if ("crear".equals(operacion)) {
                    ok = validar(nombre) && caracteristicaDAO.insertar(nombre);
                } else if ("actualizar".equals(operacion)) {
                    ok = id > 0 && validar(nombre) && caracteristicaDAO.actualizar(id, nombre);
                } else if ("eliminar".equals(operacion)) {
                    ok = id > 0 && caracteristicaDAO.eliminar(id);
                }
            }

            if (ok) {
                session.setAttribute("mensajeExito",
                        etiqueta + " " + accionTexto(operacion) + " correctamente.");
            } else {
                session.setAttribute("mensajeError",
                        "No se pudo " + accionTexto(operacion) + " " + etiqueta.toLowerCase()
                        + ". Verifique los datos (el nombre es obligatorio).");
            }

        } catch (SQLException e) {
            session.setAttribute("mensajeError", mensajeSql(e));
        }

        response.sendRedirect(request.getContextPath()
                + "/AdminParametrosServlet?tab=" + normalizarTab(request.getParameter("tab")));
    }

    // ====================================================
    // UTILIDADES
    // ====================================================

    /**
     * Carga las tres listas de parametros en el request.
     */
    private void cargarCatalogos(HttpServletRequest request) {
        try {
            request.setAttribute("ciudades", ciudadDAO.listarTodas());
            request.setAttribute("tipos", tipoPropiedadDAO.listarTodos());
            request.setAttribute("caracteristicas", caracteristicaDAO.listarTodas());
        } catch (SQLException e) {
            request.setAttribute("error", "No se pudieron cargar los parametros.");
        }
    }

    /**
     * Traduce el error SQL a un mensaje amigable (duplicado o en uso).
     */
    private String mensajeSql(SQLException e) {
        String msg = e.getMessage() != null ? e.getMessage().toLowerCase() : "";

        if (msg.contains("duplicate") || msg.contains("unique")) {
            return "Ya existe un registro con ese nombre. Use un nombre diferente.";
        }
        if (msg.contains("foreign key") || msg.contains("constraint")) {
            return "No se puede eliminar: el parametro esta en uso por una propiedad. "
                 + "Primero reasigne esas propiedades.";
        }
        return "Ocurrio un error de base de datos al guardar el parametro.";
    }

    private boolean validar(String nombre) {
        return nombre != null && !nombre.isEmpty() && nombre.length() <= 80;
    }

    private String etiquetaEntidad(String entidad) {
        if ("ciudad".equals(entidad)) return "Ciudad";
        if ("tipo".equals(entidad)) return "Tipo de propiedad";
        if ("caracteristica".equals(entidad)) return "Caracteristica";
        return "Registro";
    }

    private String accionTexto(String operacion) {
        if ("crear".equals(operacion)) return "creado";
        if ("actualizar".equals(operacion)) return "actualizado";
        if ("eliminar".equals(operacion)) return "eliminado";
        return "procesado";
    }

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

    /**
     * Normaliza el identificador de pestaña activa (para conservarla tras el
     * POST/Redirect/GET). Valores permitidos: ciudades, tipos, caracteristicas.
     */
    private String normalizarTab(String tab) {
        if ("tipos".equals(tab)) return "tipos";
        if ("caracteristicas".equals(tab)) return "caracteristicas";
        return "ciudades";
    }
}
