package com.inmobiliaria.dao;

import com.inmobiliaria.model.Usuario;
import com.inmobiliaria.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

/**
 * DAO (Data Access Object) para la entidad Usuario.
 * Implementa todas las operaciones JDBC contra la tabla 'usuario',
 * 'perfil' y 'usuario_rol' usando PreparedStatement para prevenir SQL Injection.
 */
public class UsuarioDAO {

    /**
     * Registra un nuevo cliente en el sistema dentro de una transaccion.
     * Inserta en: usuario -> perfil -> usuario_rol (rol CLIENTE = id_rol 3).
     *
     * @param correo       Correo electronico del usuario
     * @param passwordHash Contrasena cifrada con BCrypt
     * @param nombres      Nombres completos del perfil
     * @param apellidos    Apellidos completos del perfil
     * @param documento    Numero de documento de identidad
     * @return true si el registro fue exitoso, false si ocurrio un error
     * @throws SQLException si ocurre un error de integridad (correo/documento duplicado)
     */
    public boolean registrarCliente(String correo, String passwordHash,
                                    String nombres, String apellidos,
                                    String documento) throws SQLException {

        String sqlUsuario = "INSERT INTO usuario (correo, password_hash, estado, fecha_registro) "
                + "VALUES (?, ?, 1, NOW())";

        String sqlPerfil = "INSERT INTO perfil (id_usuario, nombres, apellidos, documento) "
                + "VALUES (?, ?, ?, ?)";

        String sqlRol = "INSERT INTO usuario_rol (id_usuario, id_rol, fecha_asignacion) "
                + "VALUES (?, 3, NOW())";

        Connection conn = null;
        PreparedStatement psUsuario = null;
        PreparedStatement psPerfil = null;
        PreparedStatement psRol = null;
        ResultSet rs = null;

        try {
            conn = ConexionDB.obtenerConexion();
            conn.setAutoCommit(false); // Iniciar transaccion

            // 1. Insertar en tabla usuario
            psUsuario = conn.prepareStatement(sqlUsuario, PreparedStatement.RETURN_GENERATED_KEYS);
            psUsuario.setString(1, correo);
            psUsuario.setString(2, passwordHash);
            psUsuario.executeUpdate();

            // Obtener el ID generado
            rs = psUsuario.getGeneratedKeys();
            int idUsuario = -1;
            if (rs.next()) {
                idUsuario = rs.getInt(1);
            }

            if (idUsuario == -1) {
                conn.rollback();
                return false;
            }

            // 2. Insertar en tabla perfil
            psPerfil = conn.prepareStatement(sqlPerfil);
            psPerfil.setInt(1, idUsuario);
            psPerfil.setString(2, nombres);
            psPerfil.setString(3, apellidos);
            psPerfil.setString(4, documento);
            psPerfil.executeUpdate();

            // 3. Asignar rol CLIENTE (id_rol = 3)
            psRol = conn.prepareStatement(sqlRol);
            psRol.setInt(1, idUsuario);
            psRol.executeUpdate();

            conn.commit(); // Confirmar transaccion
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Revertir en caso de error
                } catch (SQLException ignored) {
                }
            }
            throw e; // Re-lanzar para que el Servlet maneje el error
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (psRol != null) try { psRol.close(); } catch (SQLException ignored) {}
            if (psPerfil != null) try { psPerfil.close(); } catch (SQLException ignored) {}
            if (psUsuario != null) try { psUsuario.close(); } catch (SQLException ignored) {}
            ConexionDB.cerrar(conn);
        }
    }

    /**
     * Busca un usuario por su correo electronico.
     *
     * @param correo Correo a buscar
     * @return Objeto Usuario si se encuentra, null si no existe
     */
    public Usuario obtenerPorCorreo(String correo) {
        String sql = "SELECT id_usuario, correo, password_hash, estado, fecha_registro "
                + "FROM usuario WHERE correo = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = ConexionDB.obtenerConexion();
            ps = conn.prepareStatement(sql);
            ps.setString(1, correo);
            rs = ps.executeQuery();

            if (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setPasswordHash(rs.getString("password_hash"));
                usuario.setEstado(rs.getBoolean("estado"));
                usuario.setFechaRegistro(rs.getTimestamp("fecha_registro").toLocalDateTime());
                return usuario;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
            ConexionDB.cerrar(conn);
        }

        return null;
    }

    /**
     * Obtiene el nombre del rol principal asignado a un usuario.
     *
     * @param idUsuario ID del usuario
     * @return Nombre del rol (ADMINISTRADOR, INMOBILIARIA, CLIENTE) o null
     */
    public String obtenerRolPrincipal(int idUsuario) {
        String sql = "SELECT r.nombre FROM usuario_rol ur "
                + "INNER JOIN rol r ON ur.id_rol = r.id_rol "
                + "WHERE ur.id_usuario = ? "
                + "ORDER BY ur.id_rol ASC LIMIT 1";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = ConexionDB.obtenerConexion();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("nombre");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
            ConexionDB.cerrar(conn);
        }

        return null;
    }
}
