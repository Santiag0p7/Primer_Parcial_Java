package com.inmobiliaria.dao;

import com.inmobiliaria.model.Caracteristica;
import com.inmobiliaria.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO (Data Access Object) para la entidad Caracteristica.
 * Gestiona el catalogo general y la relacion N:M con 'propiedad'
 * a traves de la tabla intermedia 'propiedad_caracteristica'.
 *
 * La asignacion masiva se ejecuta dentro de una transaccion JDBC
 * (setAutoCommit(false)) para garantizar atomicidad.
 */
public class CaracteristicaDAO {

    /**
     * Consulta el catalogo general de caracteristicas.
     *
     * @return Lista completa de caracteristicas ordenada por nombre
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<Caracteristica> listarTodas() throws SQLException {
        String sql = "SELECT id_caracteristica, nombre FROM caracteristica ORDER BY nombre";

        List<Caracteristica> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(new Caracteristica(rs.getInt("id_caracteristica"), rs.getString("nombre")));
            }
        }
        return lista;
    }

    /**
     * Retorna las caracteristicas asignadas a un inmueble.
     *
     * @param idPropiedad ID de la propiedad
     * @return Lista de caracteristicas de la propiedad
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<Caracteristica> listarPorPropiedad(int idPropiedad) throws SQLException {
        String sql = "SELECT c.id_caracteristica, c.nombre "
                + "FROM caracteristica c "
                + "INNER JOIN propiedad_caracteristica pc ON c.id_caracteristica = pc.id_caracteristica "
                + "WHERE pc.id_propiedad = ? "
                + "ORDER BY c.nombre";

        List<Caracteristica> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idPropiedad);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(new Caracteristica(rs.getInt("id_caracteristica"), rs.getString("nombre")));
                }
            }
        }
        return lista;
    }

    /**
     * Retorna los IDs de las caracteristicas asignadas a un inmueble.
     * Util para marcar los checkboxes en el formulario de edicion.
     *
     * @param idPropiedad ID de la propiedad
     * @return Lista de IDs de caracteristicas
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<Integer> listarIdsPorPropiedad(int idPropiedad) throws SQLException {
        String sql = "SELECT id_caracteristica FROM propiedad_caracteristica WHERE id_propiedad = ?";

        List<Integer> ids = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idPropiedad);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("id_caracteristica"));
                }
            }
        }
        return ids;
    }

    /**
     * Actualiza las caracteristicas de una propiedad ejecutando la
     * eliminacion previa e insercion masiva dentro de una transaccion JDBC.
     *
     * @param idPropiedad        ID de la propiedad
     * @param idsCaracteristicas IDs seleccionados (puede ser null o vacio)
     * @throws SQLException si ocurre un error (se revierte la transaccion)
     */
    public void actualizarCaracteristicasPropiedad(int idPropiedad, List<Integer> idsCaracteristicas)
            throws SQLException {

        try (Connection conn = ConexionDB.obtenerConexion()) {
            boolean autoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false); // Iniciar transaccion
            try {
                actualizarCaracteristicasPropiedad(conn, idPropiedad, idsCaracteristicas);
                conn.commit(); // Confirmar transaccion
            } catch (SQLException e) {
                conn.rollback(); // Revertir ante error
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
     * @param conn               Conexion JDBC suministrada por el llamador
     * @param idPropiedad        ID de la propiedad
     * @param idsCaracteristicas IDs seleccionados (puede ser null o vacio)
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public void actualizarCaracteristicasPropiedad(Connection conn, int idPropiedad,
                                                   List<Integer> idsCaracteristicas)
            throws SQLException {

        String sqlDelete = "DELETE FROM propiedad_caracteristica WHERE id_propiedad = ?";
        String sqlInsert = "INSERT INTO propiedad_caracteristica (id_propiedad, id_caracteristica) "
                + "VALUES (?, ?)";

        // 1. Eliminar relaciones previas
        try (PreparedStatement psDel = conn.prepareStatement(sqlDelete)) {
            psDel.setInt(1, idPropiedad);
            psDel.executeUpdate();
        }

        // 2. Insercion masiva de las nuevas relaciones
        if (idsCaracteristicas != null && !idsCaracteristicas.isEmpty()) {
            try (PreparedStatement psIns = conn.prepareStatement(sqlInsert)) {
                for (Integer idCar : idsCaracteristicas) {
                    if (idCar != null) {
                        psIns.setInt(1, idPropiedad);
                        psIns.setInt(2, idCar);
                        psIns.addBatch();
                    }
                }
                psIns.executeBatch();
            }
        }
    }
}
