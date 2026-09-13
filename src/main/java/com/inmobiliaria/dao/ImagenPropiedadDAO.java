package com.inmobiliaria.dao;

import com.inmobiliaria.model.ImagenPropiedad;
import com.inmobiliaria.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO (Data Access Object) para la entidad ImagenPropiedad.
 * Gestiona la relacion 1:N entre 'propiedad' y sus imagenes
 * contra la tabla 'imagen_propiedad' usando PreparedStatement.
 */
public class ImagenPropiedadDAO {

    /**
     * Registra la URL de una foto vinculada a una propiedad.
     *
     * @param img Imagen a insertar (debe incluir idPropiedad y urlImagen)
     * @return true si se inserto correctamente
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public boolean insertar(ImagenPropiedad img) throws SQLException {
        String sql = "INSERT INTO imagen_propiedad (id_propiedad, url_imagen, es_principal) "
                + "VALUES (?, ?, ?)";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, img.getIdPropiedad());
            ps.setString(2, img.getUrlImagen());
            ps.setBoolean(3, img.isEsPrincipal());

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Retorna todas las fotos de un inmueble, priorizando la principal.
     *
     * @param idPropiedad ID de la propiedad
     * @return Lista de imagenes de la propiedad
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<ImagenPropiedad> listarPorPropiedad(int idPropiedad) throws SQLException {
        String sql = "SELECT id_imagen, id_propiedad, url_imagen, es_principal "
                + "FROM imagen_propiedad WHERE id_propiedad = ? "
                + "ORDER BY es_principal DESC, id_imagen ASC";

        List<ImagenPropiedad> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idPropiedad);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }
        return lista;
    }

    /**
     * Elimina una foto especifica de la galeria.
     *
     * @param idImagen ID de la imagen a eliminar
     * @return true si se elimino correctamente
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public boolean eliminar(int idImagen) throws SQLException {
        String sql = "DELETE FROM imagen_propiedad WHERE id_imagen = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idImagen);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Reemplaza por completo la galeria de una propiedad dentro de una
     * transaccion JDBC: elimina las imagenes previas e inserta las nuevas.
     * Si algo falla, hace rollback para no dejar datos inconsistentes.
     *
     * @param idPropiedad ID de la propiedad
     * @param urls        Lista de URLs a registrar (puede haber una principal)
     * @param urlPrincipal URL de la imagen principal (puede ser null)
     * @throws SQLException si ocurre un error (se revierte la transaccion)
     */
    public void reemplazarGaleria(int idPropiedad, List<String> urls, String urlPrincipal)
            throws SQLException {

        try (Connection conn = ConexionDB.obtenerConexion()) {
            boolean autoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);
            try {
                reemplazarGaleria(conn, idPropiedad, urls, urlPrincipal);
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(autoCommit);
            }
        }
    }

    /**
     * Variante que recibe una conexion existente para participar en una
     * transaccion coordinada externamente (ej: alta completa de propiedad).
     * NO inicia, confirma ni revierte la transaccion, y NO cierra la conexion.
     *
     * @param conn         Conexion JDBC suministrada por el llamador
     * @param idPropiedad  ID de la propiedad
     * @param urls         URLs secundarias (puede ser null)
     * @param urlPrincipal URL de la imagen principal (puede ser null)
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public void reemplazarGaleria(Connection conn, int idPropiedad, List<String> urls,
                                  String urlPrincipal) throws SQLException {

        String sqlDelete = "DELETE FROM imagen_propiedad WHERE id_propiedad = ?";
        String sqlInsert = "INSERT INTO imagen_propiedad (id_propiedad, url_imagen, es_principal) "
                + "VALUES (?, ?, ?)";

        try (PreparedStatement psDel = conn.prepareStatement(sqlDelete)) {
            psDel.setInt(1, idPropiedad);
            psDel.executeUpdate();
        }

        if (urlPrincipal != null && !urlPrincipal.trim().isEmpty()) {
            insertarUrl(conn, sqlInsert, idPropiedad, urlPrincipal.trim(), true);
        }

        if (urls != null) {
            for (String url : urls) {
                if (url != null && !url.trim().isEmpty()
                        && !url.trim().equals(urlPrincipal)) {
                    insertarUrl(conn, sqlInsert, idPropiedad, url.trim(), false);
                }
            }
        }
    }

    /**
     * Obtiene una imagen por su clave primaria.
     *
     * @param idImagen ID de la imagen
     * @return Imagen encontrada o null si no existe
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public ImagenPropiedad obtenerPorId(int idImagen) throws SQLException {
        String sql = "SELECT id_imagen, id_propiedad, url_imagen, es_principal "
                + "FROM imagen_propiedad WHERE id_imagen = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idImagen);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        }
        return null;
    }

    /**
     * Inserta una URL usando la conexion compartida de la transaccion.
     */
    private void insertarUrl(Connection conn, String sql, int idPropiedad,
                             String url, boolean principal) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPropiedad);
            ps.setString(2, url);
            ps.setBoolean(3, principal);
            ps.executeUpdate();
        }
    }

    /**
     * Mapea la fila actual del ResultSet a un objeto ImagenPropiedad.
     */
    private ImagenPropiedad mapear(ResultSet rs) throws SQLException {
        ImagenPropiedad img = new ImagenPropiedad();
        img.setIdImagen(rs.getInt("id_imagen"));
        img.setIdPropiedad(rs.getInt("id_propiedad"));
        img.setUrlImagen(rs.getString("url_imagen"));
        img.setEsPrincipal(rs.getBoolean("es_principal"));
        return img;
    }
}
