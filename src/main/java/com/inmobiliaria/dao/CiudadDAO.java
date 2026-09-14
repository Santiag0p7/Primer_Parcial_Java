package com.inmobiliaria.dao;

import com.inmobiliaria.model.Ciudad;
import com.inmobiliaria.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO (Data Access Object) para la entidad Ciudad (Sprint 3 - Item 2).
 * Implementa el CRUD de parametros usando PreparedStatement.
 */
public class CiudadDAO {

    /**
     * Lista todas las ciudades del catalogo ordenadas por nombre.
     *
     * @return Lista completa de ciudades
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<Ciudad> listarTodas() throws SQLException {
        String sql = "SELECT id_ciudad, nombre, departamento FROM ciudad ORDER BY nombre";

        List<Ciudad> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(new Ciudad(
                        rs.getInt("id_ciudad"),
                        rs.getString("nombre"),
                        rs.getString("departamento")));
            }
        }
        return lista;
    }

    /**
     * Inserta una nueva ciudad.
     *
     * @param nombre       Nombre de la ciudad (UNIQUE)
     * @param departamento Departamento (opcional)
     * @return true si se inserto correctamente
     * @throws SQLException si ocurre un error (incluye nombre duplicado)
     */
    public boolean insertar(String nombre, String departamento) throws SQLException {
        String sql = "INSERT INTO ciudad (nombre, departamento) VALUES (?, ?)";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nombre);
            setNullableString(ps, 2, departamento);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Actualiza el nombre y el departamento de una ciudad.
     *
     * @param idCiudad     ID de la ciudad
     * @param nombre       Nuevo nombre
     * @param departamento Nuevo departamento (opcional)
     * @return true si se actualizo al menos un registro
     * @throws SQLException si ocurre un error (incluye nombre duplicado)
     */
    public boolean actualizar(int idCiudad, String nombre, String departamento) throws SQLException {
        String sql = "UPDATE ciudad SET nombre = ?, departamento = ? WHERE id_ciudad = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nombre);
            setNullableString(ps, 2, departamento);
            ps.setInt(3, idCiudad);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Elimina una ciudad.
     *
     * @param idCiudad ID de la ciudad
     * @return true si se elimino correctamente
     * @throws SQLException si ocurre un error (incluye FK en uso)
     */
    public boolean eliminar(int idCiudad) throws SQLException {
        String sql = "DELETE FROM ciudad WHERE id_ciudad = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idCiudad);
            return ps.executeUpdate() > 0;
        }
    }

    private void setNullableString(PreparedStatement ps, int index, String valor)
            throws SQLException {
        if (valor == null || valor.trim().isEmpty()) {
            ps.setNull(index, Types.VARCHAR);
        } else {
            ps.setString(index, valor.trim());
        }
    }
}
