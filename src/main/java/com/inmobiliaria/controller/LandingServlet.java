package com.inmobiliaria.controller;

import com.inmobiliaria.dao.ImagenPropiedadDAO;
import com.inmobiliaria.dao.PropiedadDAO;
import com.inmobiliaria.model.ImagenPropiedad;
import com.inmobiliaria.model.Propiedad;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Controlador de la Landing Page publica.
 * Consulta la base de datos para inyectar el catalogo real de tipos/ciudades
 * y las propiedades activas destacadas en index.jsp.
 */
public class LandingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final PropiedadDAO propiedadDAO = new PropiedadDAO();
    private final ImagenPropiedadDAO imagenDAO = new ImagenPropiedadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Catalogos reales desde la BD (id -> nombre)
            Map<Integer, String> tipos = propiedadDAO.listarTipos();
            Map<Integer, String> ciudades = propiedadDAO.listarCiudades();

            // Propiedades activas para el catalogo destacado
            List<Propiedad> destacadas = propiedadDAO.listarTodasActivas();

            // Mapa idPropiedad -> url de imagen principal para las tarjetas
            Map<Integer, String> imagenesPrincipales = new HashMap<>();
            for (Propiedad p : destacadas) {
                List<ImagenPropiedad> imgs = imagenDAO.listarPorPropiedad(p.getIdPropiedad());
                if (!imgs.isEmpty()) {
                    imagenesPrincipales.put(p.getIdPropiedad(), imgs.get(0).getUrlImagen());
                }
            }

            request.setAttribute("tipos", tipos);
            request.setAttribute("ciudades", ciudades);
            request.setAttribute("propiedadesDestacadas", destacadas);
            request.setAttribute("imagenesPrincipales", imagenesPrincipales);
            request.setAttribute("tituloPagina", "Inmobiliaria UTS - Tu Hogar Ideal");

        } catch (SQLException e) {
            // Si falla la BD, la landing sigue funcionando sin datos dinamicos
            request.setAttribute("errorCatalogo",
                    "No se pudo cargar el catalogo en este momento.");
        }

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
