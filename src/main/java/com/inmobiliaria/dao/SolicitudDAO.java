package com.inmobiliaria.dao;

import com.inmobiliaria.model.DocumentoSolicitud;
import com.inmobiliaria.model.Solicitud;
import com.inmobiliaria.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO (Data Access Object) para el modulo de Solicitudes de compra/arriendo
 * y sus documentos (tablas 'solicitud' y 'documento_solicitud').
 * Usa PreparedStatement para prevenir SQL Injection.
 */
public class SolicitudDAO {

    // SELECT base con JOIN a propiedad, ciudad, usuario (cliente) y perfil
    private static final String SELECT_BASE =
            "SELECT s.id_solicitud, s.id_propiedad, s.id_cliente, s.tipo, s.monto_oferta, "
          + "s.mensaje, s.estado, s.observacion, s.fecha_creacion, s.fecha_actualizacion, "
          + "p.titulo AS titulo_propiedad, p.id_inmobiliaria AS id_inmobiliaria, "
          + "c.nombre AS nombre_ciudad, "
          + "COALESCE(CONCAT(pf.nombres, ' ', pf.apellidos), u.correo) AS nombre_cliente, "
          + "u.correo AS correo_cliente "
          + "FROM solicitud s "
          + "INNER JOIN propiedad p ON s.id_propiedad = p.id_propiedad "
          + "INNER JOIN ciudad c ON p.id_ciudad = c.id_ciudad "
          + "INNER JOIN usuario u ON s.id_cliente = u.id_usuario "
          + "LEFT JOIN perfil pf ON u.id_usuario = pf.id_usuario ";

    /**
     * Registra una nueva solicitud de compra/arriendo en estado PENDIENTE.
     *
     * @return ID generado, o -1 si no se pudo insertar
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public int crearSolicitud(Solicitud s) throws SQLException {
        String sql = "INSERT INTO solicitud "
                + "(id_propiedad, id_cliente, tipo, monto_oferta, mensaje, estado, fecha_creacion) "
                + "VALUES (?, ?, ?, ?, ?, 'PENDIENTE', NOW())";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, s.getIdPropiedad());
            ps.setInt(2, s.getIdCliente());
            ps.setString(3, s.getTipo());

            if (s.getMontoOferta() == null) {
                ps.setNull(4, Types.DECIMAL);
            } else {
                ps.setBigDecimal(4, s.getMontoOferta());
            }

            if (s.getMensaje() == null || s.getMensaje().trim().isEmpty()) {
                ps.setNull(5, Types.VARCHAR);
            } else {
                ps.setString(5, s.getMensaje().trim());
            }

            if (ps.executeUpdate() == 0) {
                return -1;
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getInt(1) : -1;
            }
        }
    }

    /**
     * Obtiene una solicitud por su clave primaria.
     *
     * @return Solicitud encontrada o null si no existe
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public Solicitud obtenerPorId(int idSolicitud) throws SQLException {
        String sql = SELECT_BASE + "WHERE s.id_solicitud = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idSolicitud);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    /**
     * Lista las solicitudes realizadas por un cliente (mas recientes primero).
     *
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<Solicitud> listarPorCliente(int idCliente) throws SQLException {
        String sql = SELECT_BASE
                + "WHERE s.id_cliente = ? "
                + "ORDER BY s.fecha_creacion DESC";
        return consultar(sql, idCliente);
    }

    /**
     * Lista las solicitudes recibidas por una inmobiliaria (prioriza PENDIENTES).
     *
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<Solicitud> listarPorInmobiliaria(int idInmobiliaria) throws SQLException {
        String sql = SELECT_BASE
                + "WHERE p.id_inmobiliaria = ? "
                + "ORDER BY FIELD(s.estado, 'PENDIENTE', 'EN_REVISION', 'APROBADA', 'RECHAZADA', 'CANCELADA'), "
                + "s.fecha_creacion DESC";
        return consultar(sql, idInmobiliaria);
    }

    /**
     * Actualiza el estado y la observacion de una solicitud.
     *
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public boolean cambiarEstado(int idSolicitud, String estado, String observacion) throws SQLException {
        String sql = "UPDATE solicitud SET estado = ?, observacion = ?, fecha_actualizacion = NOW() "
                + "WHERE id_solicitud = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, estado);
            if (observacion == null || observacion.trim().isEmpty()) {
                ps.setNull(2, Types.VARCHAR);
            } else {
                ps.setString(2, observacion.trim());
            }
            ps.setInt(3, idSolicitud);
            return ps.executeUpdate() > 0;
        }
    }

    // ====================================================
    // DOCUMENTOS
    // ====================================================

    /**
     * Agrega un documento a una solicitud.
     *
     * @return true si se inserto correctamente
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public boolean agregarDocumento(DocumentoSolicitud d) throws SQLException {
        String sql = "INSERT INTO documento_solicitud "
                + "(id_solicitud, tipo, nombre, url_documento, fecha_carga) "
                + "VALUES (?, ?, ?, ?, NOW())";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, d.getIdSolicitud());
            if (d.getTipo() == null || d.getTipo().trim().isEmpty()) {
                ps.setNull(2, Types.VARCHAR);
            } else {
                ps.setString(2, d.getTipo().trim());
            }
            ps.setString(3, d.getNombre().trim());
            ps.setString(4, d.getUrlDocumento().trim());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lista los documentos de una solicitud.
     *
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<DocumentoSolicitud> listarDocumentos(int idSolicitud) throws SQLException {
        String sql = "SELECT id_documento, id_solicitud, tipo, nombre, url_documento, fecha_carga "
                + "FROM documento_solicitud WHERE id_solicitud = ? ORDER BY fecha_carga DESC";

        List<DocumentoSolicitud> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idSolicitud);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DocumentoSolicitud d = new DocumentoSolicitud();
                    d.setIdDocumento(rs.getInt("id_documento"));
                    d.setIdSolicitud(rs.getInt("id_solicitud"));
                    d.setTipo(rs.getString("tipo"));
                    d.setNombre(rs.getString("nombre"));
                    d.setUrlDocumento(rs.getString("url_documento"));
                    java.sql.Timestamp f = rs.getTimestamp("fecha_carga");
                    if (f != null) {
                        d.setFechaCarga(f.toLocalDateTime());
                    }
                    lista.add(d);
                }
            }
        }
        return lista;
    }

    /**
     * Obtiene un documento por su clave primaria (para validar permisos).
     *
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public DocumentoSolicitud obtenerDocumento(int idDocumento) throws SQLException {
        String sql = "SELECT id_documento, id_solicitud, tipo, nombre, url_documento, fecha_carga "
                + "FROM documento_solicitud WHERE id_documento = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idDocumento);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DocumentoSolicitud d = new DocumentoSolicitud();
                    d.setIdDocumento(rs.getInt("id_documento"));
                    d.setIdSolicitud(rs.getInt("id_solicitud"));
                    d.setTipo(rs.getString("tipo"));
                    d.setNombre(rs.getString("nombre"));
                    d.setUrlDocumento(rs.getString("url_documento"));
                    return d;
                }
            }
        }
        return null;
    }

    /**
     * Elimina un documento de una solicitud.
     *
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public boolean eliminarDocumento(int idDocumento) throws SQLException {
        String sql = "DELETE FROM documento_solicitud WHERE id_documento = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idDocumento);
            return ps.executeUpdate() > 0;
        }
    }

    // ====================================================
    // UTILIDADES
    // ====================================================

    private List<Solicitud> consultar(String sql, int parametro) throws SQLException {
        List<Solicitud> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, parametro);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }
        return lista;
    }

    private Solicitud mapear(ResultSet rs) throws SQLException {
        Solicitud s = new Solicitud();
        s.setIdSolicitud(rs.getInt("id_solicitud"));
        s.setIdPropiedad(rs.getInt("id_propiedad"));
        s.setIdCliente(rs.getInt("id_cliente"));
        s.setTipo(rs.getString("tipo"));
        s.setMontoOferta(rs.getBigDecimal("monto_oferta"));
        s.setMensaje(rs.getString("mensaje"));
        s.setEstado(rs.getString("estado"));
        s.setObservacion(rs.getString("observacion"));

        java.sql.Timestamp fc = rs.getTimestamp("fecha_creacion");
        if (fc != null) {
            s.setFechaCreacion(fc.toLocalDateTime());
        }
        java.sql.Timestamp fa = rs.getTimestamp("fecha_actualizacion");
        if (fa != null) {
            s.setFechaActualizacion(fa.toLocalDateTime());
        }

        s.setTituloPropiedad(rs.getString("titulo_propiedad"));
        s.setIdInmobiliaria(rs.getInt("id_inmobiliaria"));
        s.setNombreCiudad(rs.getString("nombre_ciudad"));
        s.setNombreCliente(rs.getString("nombre_cliente"));
        s.setCorreoCliente(rs.getString("correo_cliente"));
        return s;
    }
}
