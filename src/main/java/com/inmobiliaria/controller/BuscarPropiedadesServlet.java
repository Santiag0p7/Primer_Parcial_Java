package com.inmobiliaria.controller;

import com.inmobiliaria.dao.CaracteristicaDAO;
import com.inmobiliaria.dao.ImagenPropiedadDAO;
import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.model.ImagenPropiedad;
import com.inmobiliaria.model.Propiedad;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controlador del buscador publico del catalogo.
 * Mapeado a /buscar.
 *
 * Filtros soportados (todos opcionales):
 *   idCiudad / ciudad   -> ciudad del inmueble
 *   idTipo / tipo       -> tipo de inmueble
 *   precio_min          -> precio minimo
 *   precio_max          -> precio maximo
 *   q / palabra         -> palabra clave en titulo o descripcion
 *
 * Solo lista propiedades activas (estado_logico = TRUE).
 */
public class BuscarPropiedadesServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final PropiedadDAO propiedadDAO = new PropiedadDAO();
    private final ImagenPropiedadDAO imagenDAO = new ImagenPropiedadDAO();
    private final CaracteristicaDAO caracteristicaDAO = new CaracteristicaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer idCiudad = parseEnteroOpcional(primeroNoVacio(
                request.getParameter("idCiudad"), request.getParameter("ciudad")));
        Integer idTipo = parseEnteroOpcional(primeroNoVacio(
                request.getParameter("idTipo"), request.getParameter("tipo")));
        BigDecimal precioMin = parseDecimalOpcional(request.getParameter("precio_min"));
        BigDecimal precioMax = parseDecimalOpcional(request.getParameter("precio_max"));
        String palabra = primeroNoVacio(request.getParameter("q"), request.getParameter("palabra"));
        Integer idCaracteristica = parseEnteroOpcional(request.getParameter("idCaracteristica"));

        try {
            List<Propiedad> resultados = propiedadDAO.buscarConFiltros(
                    idCiudad, idTipo, precioMin, precioMax, palabra, idCaracteristica);

            // Imagen principal de cada resultado para las tarjetas
            Map<Integer, String> imagenesPrincipales = new HashMap<>();
            for (Propiedad p : resultados) {
                List<ImagenPropiedad> imgs = imagenDAO.listarPorPropiedad(p.getIdPropiedad());
                if (!imgs.isEmpty()) {
                    imagenesPrincipales.put(p.getIdPropiedad(), imgs.get(0).getUrlImagen());
                }
            }

            request.setAttribute("propiedades", resultados);
            request.setAttribute("imagenesPrincipales", imagenesPrincipales);
            request.setAttribute("hayFiltros", hayFiltros(idCiudad, idTipo, precioMin, precioMax, palabra, idCaracteristica));
            request.setAttribute("filtroCiudad", idCiudad);
            request.setAttribute("filtroTipo", idTipo);
            request.setAttribute("filtroPrecioMin", precioMin);
            request.setAttribute("filtroPrecioMax", precioMax);
            request.setAttribute("filtroPalabra", palabra);
            request.setAttribute("filtroCaracteristica", idCaracteristica);

        } catch (SQLException e) {
            request.setAttribute("errorCatalogo",
                    "No se pudo ejecutar la busqueda. Intente nuevamente.");
        }

        // Catalogos para el panel de filtros
        try {
            request.setAttribute("tipos", propiedadDAO.listarTipos());
            request.setAttribute("ciudades", propiedadDAO.listarCiudades());
            request.setAttribute("caracteristicas", caracteristicaDAO.listarTodas());
        } catch (SQLException ignored) {
        }

        request.setAttribute("tituloPagina", "Catalogo de Propiedades - JSGE In-Mobiliaria");
        request.getRequestDispatcher("/catalogo.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // ====================================================
    // UTILIDADES
    // ====================================================

    private boolean hayFiltros(Integer idCiudad, Integer idTipo, BigDecimal min,
                               BigDecimal max, String palabra, Integer idCaracteristica) {
        return (idCiudad != null && idCiudad > 0)
                || (idTipo != null && idTipo > 0)
                || min != null || max != null
                || (idCaracteristica != null && idCaracteristica > 0)
                || (palabra != null && !palabra.trim().isEmpty());
    }

    private String primeroNoVacio(String a, String b) {
        if (a != null && !a.trim().isEmpty()) {
            return a.trim();
        }
        if (b != null && !b.trim().isEmpty()) {
            return b.trim();
        }
        return null;
    }

    private Integer parseEnteroOpcional(String valor) {
        if (valor == null || valor.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(valor.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private BigDecimal parseDecimalOpcional(String valor) {
        if (valor == null || valor.trim().isEmpty()) {
            return null;
        }
        try {
            return new BigDecimal(valor.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
