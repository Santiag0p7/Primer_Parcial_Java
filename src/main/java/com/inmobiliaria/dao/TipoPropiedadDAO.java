package com.inmobiliaria.dao;

import com.inmobiliaria.model.TipoPropiedad;
import com.inmobiliaria.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO (Data Access Object) para la entidad TipoPropiedad (Sprint 3 - Item 2).
 * Implementa el CRUD de parametros usando PreparedStatement.
 */
public class TipoPropiedadDAO {

    /**
     * Lista todos los tipos de propiedad ordenados por nombre.
     *
     * @return Lista completa de tipos de propiedad
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<TipoPropiedad> listarTodos() throws SQLException {
        String sql = "SELECT id_tipo, nombre FROM tipo_propiedad ORDER BY nombre";

        List<TipoPropiedad> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(new TipoPropiedad(rs.getInt("id_tipo"), rs.getString("nombre")));
            }
        }
        return lista;
    }

    /**
     * Inserta un nuevo tipo de propiedad.
     *
     * @param nombre Nombre del tipo (UNIQUE)
     * @return true si se inserto correctamente
     * @throws SQLException si ocurre un error (incluye nombre duplicado)
     */
    public boolean insertar(String nombre) throws SQLException {
        String sql = "INSERT INTO tipo_propiedad (nombre) VALUES (?)";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nombre);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Actualiza el nombre de un tipo de propiedad.
     *
     * @param idTipo ID del tipo
     * @param nombre Nuevo nombre
     * @return true si se actualizo al menos un registro
     * @throws SQLException si ocurre un error (incluye nombre duplicado)
     */
    public boolean actualizar(int idTipo, String nombre) throws SQLException {
        String sql = "UPDATE tipo_propiedad SET nombre = ? WHERE id_tipo = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nombre);
            ps.setInt(2, idTipo);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Elimina un tipo de propiedad.
     *
     * @param idTipo ID del tipo
     * @return true si se elimino correctamente
     * @throws SQLException si ocurre un error (incluye FK en uso)
     */
    public boolean eliminar(int idTipo) throws SQLException {
        String sql = "DELETE FROM tipo_propiedad WHERE id_tipo = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idTipo);
            return ps.executeUpdate() > 0;
        }
    }
}
