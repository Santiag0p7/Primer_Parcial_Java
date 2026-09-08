package com.inmobiliaria.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LandingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);

        List<Map<String, String>> tiposInmueble = new ArrayList<>();
        tiposInmueble.add(Map.of("valor", "casa", "etiqueta", "Casa"));
        tiposInmueble.add(Map.of("valor", "apartamento", "etiqueta", "Apartamento"));
        tiposInmueble.add(Map.of("valor", "local", "etiqueta", "Local Comercial"));
        tiposInmueble.add(Map.of("valor", "oficina", "etiqueta", "Oficina"));
        tiposInmueble.add(Map.of("valor", "terreno", "etiqueta", "Terreno"));

        List<Map<String, String>> ciudades = new ArrayList<>();
        ciudades.add(Map.of("valor", "bucaramanga", "etiqueta", "Bucaramanga"));
        ciudades.add(Map.of("valor", "floridablanca", "etiqueta", "Floridablanca"));
        ciudades.add(Map.of("valor", "giron", "etiqueta", "Giron"));
        ciudades.add(Map.of("valor", "piedecuesta", "etiqueta", "Piedecuesta"));

        List<Map<String, String>> operaciones = new ArrayList<>();
        operaciones.add(Map.of("valor", "venta", "etiqueta", "Venta"));
        operaciones.add(Map.of("valor", "arriendo", "etiqueta", "Arriendo"));

        request.setAttribute("tiposInmueble", tiposInmueble);
        request.setAttribute("ciudades", ciudades);
        request.setAttribute("operaciones", operaciones);
        request.setAttribute("tituloPagina", "Inmobiliaria UTS - Tu Hogar Ideal");

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
