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
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Controlador del CRUD de Propiedades (Sprint 2).
 * Mapeado a /PropiedadServlet.
 *
 * Acciones soportadas mediante el parametro 'action':
 *   list        -> lista las propiedades de la inmobiliaria en sesion
 *   new         -> muestra el formulario vacio
 *   insert      -> inserta una nueva propiedad (+ caracteristicas + galeria)
 *   edit        -> muestra el formulario con los datos de la propiedad
 *   update      -> actualiza una propiedad existente (+ caracteristicas)
 *   delete      -> BAJA LOGICA (no borra fisicamente)
 *   galeria     -> vista de gestion de imagenes de una propiedad
 *   addImage    -> agrega una URL de imagen a la galeria
 *   deleteImage -> elimina una imagen de la galeria
 *
 * La restriccion UNIQUE de matricula_inmobiliaria se captura como
 * SQLException y se reenvia a la vista como alerta amigable.
 */
public class PropiedadServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final PropiedadDAO propiedadDAO = new PropiedadDAO();
    private final CaracteristicaDAO caracteristicaDAO = new CaracteristicaDAO();
    private final ImagenPropiedadDAO imagenDAO = new ImagenPropiedadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            // Acceso por URL amigable /propiedad?id=X -> ficha de detalle
            if ("/propiedad".equals(request.getServletPath())) {
                action = "detail";
            } else {
                action = "list";
            }
        }

        try {
            switch (action) {
                case "new":
                    mostrarFormulario(request, response, null);
                    break;
                case "edit":
                    mostrarEdicion(request, response);
                    break;
                case "delete":
                    ejecutarBajaLogica(request, response);
                    break;
                case "galeria":
                    mostrarGaleria(request, response);
                    break;
                case "detail":
                    mostrarDetalle(request, response);
                    break;
                case "deleteImage":
                    eliminarImagen(request, response);
                    break;
                case "list":
                default:
                    listar(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Error de base de datos al procesar la solicitud.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "insert":
                    insertar(request, response);
                    break;
                case "update":
                    actualizar(request, response);
                    break;
                case "addImage":
                    agregarImagen(request, response);
                    break;
                default:
                    listar(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Error de base de datos al procesar la solicitud.", e);
        }
    }

    // ====================================================
    // ACCIONES
    // ====================================================

    /**
     * Lista las propiedades activas de la inmobiliaria en sesion.
     */
    private void listar(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int idInmobiliaria = obtenerIdInmobiliaria(request);
        List<Propiedad> propiedades = propiedadDAO.listarPorInmobiliaria(idInmobiliaria);

        request.setAttribute("propiedades", propiedades);
        request.setAttribute("tituloPagina", "Mis Propiedades - Inmobiliaria UTS");
        request.getRequestDispatcher("/dashboard/agente/mis_propiedades.jsp")
               .forward(request, response);
    }

    /**
     * Muestra el formulario de creacion (propiedad == null) o edicion.
     * Carga los catalogos de tipos/ciudades, el catalogo de caracteristicas,
     * las caracteristicas ya asignadas y la galeria (si es edicion).
     */
    private void mostrarFormulario(HttpServletRequest request, HttpServletResponse response,
                                   Propiedad propiedad)
            throws SQLException, ServletException, IOException {

        request.setAttribute("propiedad", propiedad);
        request.setAttribute("tipos", propiedadDAO.listarTipos());
        request.setAttribute("ciudades", propiedadDAO.listarCiudades());
        request.setAttribute("caracteristicas", caracteristicaDAO.listarTodas());

        List<Integer> idsSeleccionados = new ArrayList<>();
        List<ImagenPropiedad> imagenes = new ArrayList<>();

        if (propiedad != null && propiedad.getIdPropiedad() > 0) {
            idsSeleccionados = caracteristicaDAO.listarIdsPorPropiedad(propiedad.getIdPropiedad());
            imagenes = imagenDAO.listarPorPropiedad(propiedad.getIdPropiedad());
        }

        request.setAttribute("idsSeleccionados", idsSeleccionados);
        request.setAttribute("imagenes", imagenes);
        request.setAttribute("tituloPagina", "Propiedad - Inmobiliaria UTS");
        request.getRequestDispatcher("/dashboard/agente/formulario_propiedad.jsp")
               .forward(request, response);
    }

    /**
     * Carga una propiedad existente y muestra el formulario de edicion.
     */
    private void mostrarEdicion(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = parseEntero(request.getParameter("id"), 0);

        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/PropiedadServlet?action=list");
            return;
        }

        Propiedad propiedad = propiedadDAO.obtenerPorId(id);

        if (propiedad == null) {
            request.getSession().setAttribute("mensajeError",
                    "La propiedad solicitada no existe.");
            response.sendRedirect(request.getContextPath() + "/PropiedadServlet?action=list");
            return;
        }

        mostrarFormulario(request, response, propiedad);
    }

    /**
     * Inserta una nueva propiedad capturando el error UNIQUE.
     * Tras insertar, guarda la relacion N:M de caracteristicas y
     * la galeria de imagenes de la propiedad.
     */
    private void insertar(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        Propiedad p = construirDesdeRequest(request);

        try {
            int idGenerado = propiedadDAO.insertarYRetornarId(p);

            if (idGenerado > 0) {
                // Relacion N:M (caracteristicas) con transaccion interna
                caracteristicaDAO.actualizarCaracteristicasPropiedad(
                        idGenerado, obtenerCaracteristicas(request));

                // Galeria de imagenes (1:N) con transaccion interna
                String urlPrincipal = trim(request.getParameter("urlPrincipal"));
                imagenDAO.reemplazarGaleria(idGenerado,
                        parseUrlsAdicionales(request.getParameter("urlsImagenes")),
                        urlPrincipal);

                request.getSession().setAttribute("mensajeExito",
                        "Propiedad registrada correctamente.");
                response.sendRedirect(request.getContextPath() + "/PropiedadServlet?action=list");
                return;
            }

            request.setAttribute("error", "No se pudo registrar la propiedad. Intente de nuevo.");
            mostrarFormulario(request, response, p);

        } catch (SQLException e) {
            request.setAttribute("error", mensajeUnico(e));
            mostrarFormulario(request, response, p);
        }
    }

    /**
     * Actualiza una propiedad capturando el error UNIQUE.
     * Actualiza tambien las caracteristicas N:M y la galeria de imagenes.
     */
    private void actualizar(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = parseEntero(request.getParameter("idPropiedad"), 0);

        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/PropiedadServlet?action=list");
            return;
        }

        Propiedad p = construirDesdeRequest(request);
        p.setIdPropiedad(id);

        try {
            boolean ok = propiedadDAO.actualizar(p);

            if (ok) {
                // Actualizar relacion N:M de caracteristicas
                caracteristicaDAO.actualizarCaracteristicasPropiedad(
                        id, obtenerCaracteristicas(request));

                // Actualizar galeria de imagenes (1:N)
                String urlPrincipal = trim(request.getParameter("urlPrincipal"));
                imagenDAO.reemplazarGaleria(id,
                        parseUrlsAdicionales(request.getParameter("urlsImagenes")),
                        urlPrincipal);

                request.getSession().setAttribute("mensajeExito",
                        "Propiedad actualizada correctamente.");
                response.sendRedirect(request.getContextPath() + "/PropiedadServlet?action=list");
                return;
            }

            request.setAttribute("error", "No se pudo actualizar la propiedad. Intente de nuevo.");
            mostrarFormulario(request, response, p);

        } catch (SQLException e) {
            request.setAttribute("error", mensajeUnico(e));
            mostrarFormulario(request, response, p);
        }
    }

    /**
     * REQUISITO DEL PARCIAL: la accion delete ejecuta BAJA LOGICA.
     */
    private void ejecutarBajaLogica(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int id = parseEntero(request.getParameter("id"), 0);

        if (id > 0) {
            boolean ok = propiedadDAO.bajaLogica(id);
            request.getSession().setAttribute(
                    ok ? "mensajeExito" : "mensajeError",
                    ok ? "Propiedad desactivada correctamente."
                       : "No se pudo desactivar la propiedad.");
        }

        response.sendRedirect(request.getContextPath() + "/PropiedadServlet?action=list");
    }

    /**
     * Muestra la ficha de detalle publica de una propiedad con su
     * galeria de imagenes (1:N) y sus caracteristicas asignadas (N:M).
     */
    private void mostrarDetalle(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = parseEntero(request.getParameter("id"), 0);

        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/buscar");
            return;
        }

        Propiedad propiedad = propiedadDAO.obtenerPorId(id);

        if (propiedad == null || !propiedad.isEstadoLogico()) {
            request.getSession().setAttribute("mensajeError",
                    "La propiedad solicitada no existe o no esta disponible.");
            response.sendRedirect(request.getContextPath() + "/buscar");
            return;
        }

        request.setAttribute("propiedad", propiedad);
        request.setAttribute("imagenes", imagenDAO.listarPorPropiedad(id));
        request.setAttribute("caracteristicas", caracteristicaDAO.listarPorPropiedad(id));
        request.setAttribute("tituloPagina", propiedad.getTitulo() + " - Inmobiliaria UTS");
        request.getRequestDispatcher("/detalle_propiedad.jsp")
               .forward(request, response);
    }

    /**
     * Muestra la vista de gestion de la galeria de imagenes de una propiedad.
     */
    private void mostrarGaleria(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = parseEntero(request.getParameter("id"), 0);

        if (id <= 0) {
            response.sendRedirect(request.getContextPath() + "/PropiedadServlet?action=list");
            return;
        }

        Propiedad propiedad = propiedadDAO.obtenerPorId(id);

        if (propiedad == null) {
            request.getSession().setAttribute("mensajeError",
                    "La propiedad solicitada no existe.");
            response.sendRedirect(request.getContextPath() + "/PropiedadServlet?action=list");
            return;
        }

        request.setAttribute("propiedad", propiedad);
        request.setAttribute("imagenes", imagenDAO.listarPorPropiedad(id));
        request.setAttribute("tituloPagina", "Galeria - Inmobiliaria UTS");
        request.getRequestDispatcher("/dashboard/agente/galeria_propiedad.jsp")
               .forward(request, response);
    }

    /**
     * Agrega una URL de imagen a la galeria de una propiedad.
     */
    private void agregarImagen(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int idPropiedad = parseEntero(request.getParameter("idPropiedad"), 0);
        String url = trim(request.getParameter("urlImagen"));
        boolean esPrincipal = "true".equals(request.getParameter("esPrincipal"));

        if (idPropiedad > 0 && !url.isEmpty()) {
            ImagenPropiedad img = new ImagenPropiedad();
            img.setIdPropiedad(idPropiedad);
            img.setUrlImagen(url);
            img.setEsPrincipal(esPrincipal);

            boolean ok = imagenDAO.insertar(img);
            request.getSession().setAttribute(
                    ok ? "mensajeExito" : "mensajeError",
                    ok ? "Imagen agregada correctamente."
                       : "No se pudo agregar la imagen.");
        }

        response.sendRedirect(request.getContextPath()
                + "/PropiedadServlet?action=galeria&id=" + idPropiedad);
    }

    /**
     * Elimina una imagen de la galeria (borrado fisico de la foto).
     */
    private void eliminarImagen(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int idImagen = parseEntero(request.getParameter("idImagen"), 0);
        int idPropiedad = parseEntero(request.getParameter("idPropiedad"), 0);

        if (idImagen > 0) {
            boolean ok = imagenDAO.eliminar(idImagen);
            request.getSession().setAttribute(
                    ok ? "mensajeExito" : "mensajeError",
                    ok ? "Imagen eliminada correctamente."
                       : "No se pudo eliminar la imagen.");
        }

        response.sendRedirect(request.getContextPath()
                + "/PropiedadServlet?action=galeria&id=" + idPropiedad);
    }

    // ====================================================
    // UTILIDADES
    // ====================================================

    /**
     * Construye un objeto Propiedad a partir de los parametros del formulario.
     * El idInmobiliaria SIEMPRE se toma de la sesion para evitar manipulacion.
     */
    private Propiedad construirDesdeRequest(HttpServletRequest request) {
        Propiedad p = new Propiedad();

        p.setMatriculaInmobiliaria(trim(request.getParameter("matriculaInmobiliaria")));
        p.setTitulo(trim(request.getParameter("titulo")));
        p.setDescripcion(trim(request.getParameter("descripcion")));
        p.setPrecio(parseDecimal(request.getParameter("precio")));
        p.setHabitaciones(parseEntero(request.getParameter("habitaciones"), 0));
        p.setBanos(parseEntero(request.getParameter("banos"), 0));
        p.setAreaM2(parseDecimal(request.getParameter("areaM2")));
        p.setDireccion(trim(request.getParameter("direccion")));
        p.setIdTipo(parseEntero(request.getParameter("idTipo"), 0));
        p.setIdCiudad(parseEntero(request.getParameter("idCiudad"), 0));
        p.setIdInmobiliaria(obtenerIdInmobiliaria(request));

        return p;
    }

    /**
     * Captura el arreglo de checkboxes 'caracteristicas' enviado por el
     * formulario y lo convierte en una lista de IDs enteros.
     *
     * @param request Peticion HTTP
     * @return Lista de IDs de caracteristicas seleccionados (nunca null)
     */
    private List<Integer> obtenerCaracteristicas(HttpServletRequest request) {
        List<Integer> ids = new ArrayList<>();
        String[] valores = request.getParameterValues("caracteristicas");

        if (valores != null) {
            for (String valor : valores) {
                try {
                    ids.add(Integer.parseInt(valor.trim()));
                } catch (NumberFormatException ignored) {
                    // Ignorar valores invalidos
                }
            }
        }
        return ids;
    }

    /**
     * Convierte el contenido del textarea de URLs adicionales (una por linea)
     * en una lista de cadenas limpias, ignorando lineas vacias.
     *
     * @param texto Contenido crudo del textarea (puede ser null)
     * @return Lista de URLs adicionales (nunca null)
     */
    private List<String> parseUrlsAdicionales(String texto) {
        List<String> urls = new ArrayList<>();
        if (texto == null || texto.trim().isEmpty()) {
            return urls;
        }
        for (String linea : texto.split("\\r?\\n")) {
            String url = linea.trim();
            if (!url.isEmpty()) {
                urls.add(url);
            }
        }
        return urls;
    }

    /**
     * Obtiene el ID de la inmobiliaria desde la sesion del usuario autenticado.
     */
    private int obtenerIdInmobiliaria(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("idUsuario") != null) {
            return (Integer) session.getAttribute("idUsuario");
        }
        return 0;
    }

    /**
     * Devuelve un mensaje amigable segun el error SQL.
     * Traduce la violacion UNIQUE de matricula_inmobiliaria.
     */
    private String mensajeUnico(SQLException e) {
        String mensaje = e.getMessage();
        if (mensaje != null && mensaje.toLowerCase().contains("matricula")) {
            return "La matricula inmobiliaria ya se encuentra registrada. "
                 + "Verifique el numero e intente nuevamente.";
        }
        return "No se pudo guardar la propiedad. Verifique los datos e intente de nuevo.";
    }

    private String trim(String valor) {
        return valor != null ? valor.trim() : "";
    }

    private int parseEntero(String valor, int porDefecto) {
        try {
            return Integer.parseInt(valor.trim());
        } catch (Exception e) {
            return porDefecto;
        }
    }

    private BigDecimal parseDecimal(String valor) {
        if (valor == null || valor.trim().isEmpty()) {
            return BigDecimal.ZERO;
        }
        try {
            return new BigDecimal(valor.trim());
        } catch (NumberFormatException e) {
            return BigDecimal.ZERO;
        }
    }
}
