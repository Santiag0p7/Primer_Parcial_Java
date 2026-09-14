package com.inmobiliaria.dao;

import com.inmobiliaria.model.SolicitudVisita;
import com.inmobiliaria.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO (Data Access Object) para la entidad SolicitudVisita (Sprint 3 - Item 1).
 * Implementa las operaciones JDBC contra la tabla 'solicitud_visita' usando
 * PreparedStatement para prevenir SQL Injection.
 *
 * Las consultas de listado cruzan la solicitud con la propiedad, el usuario
 * cliente y su perfil, para devolver informacion legible en las vistas.
 */
public class SolicitudVisitaDAO {

    // SELECT base con JOIN a propiedad, usuario (cliente) y perfil
    private static final String SELECT_BASE =
            "SELECT sv.id_solicitud, sv.id_propiedad, sv.id_cliente, sv.fecha_visita, "
          + "sv.hora_visita, sv.comentario, sv.estado, sv.fecha_creacion, "
          + "p.titulo AS titulo_propiedad, p.id_inmobiliaria AS id_inmobiliaria, "
          + "COALESCE(CONCAT(pf.nombres, ' ', pf.apellidos), u.correo) AS nombre_cliente, "
          + "u.correo AS correo_cliente "
          + "FROM solicitud_visita sv "
          + "INNER JOIN propiedad p ON sv.id_propiedad = p.id_propiedad "
          + "INNER JOIN usuario u ON sv.id_cliente = u.id_usuario "
          + "LEFT JOIN perfil pf ON u.id_usuario = pf.id_usuario ";

    /**
     * Registra una nueva solicitud de visita en estado PENDIENTE.
     *
     * @param sol Solicitud con idPropiedad, idCliente, fecha, hora y comentario
     * @return true si se inserto correctamente
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public boolean crearSolicitud(SolicitudVisita sol) throws SQLException {
        String sql = "INSERT INTO solicitud_visita "
                + "(id_propiedad, id_cliente, fecha_visita, hora_visita, comentario, estado, fecha_creacion) "
                + "VALUES (?, ?, ?, ?, ?, ?, NOW())";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sol.getIdPropiedad());
            ps.setInt(2, sol.getIdCliente());
            ps.setDate(3, java.sql.Date.valueOf(sol.getFechaVisita()));
            ps.setTime(4, java.sql.Time.valueOf(sol.getHoraVisita()));

            if (sol.getComentario() == null || sol.getComentario().trim().isEmpty()) {
                ps.setNull(5, Types.VARCHAR);
            } else {
                ps.setString(5, sol.getComentario().trim());
            }

            ps.setString(6, sol.getEstado() != null ? sol.getEstado() : "PENDIENTE");

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lista las solicitudes realizadas por un cliente especifico.
     *
     * @param idCliente ID del usuario (cliente) que creo las solicitudes
     * @return Lista de solicitudes del cliente (mas recientes primero)
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<SolicitudVisita> listarPorCliente(int idCliente) throws SQLException {
        String sql = SELECT_BASE
                + "WHERE sv.id_cliente = ? "
                + "ORDER BY sv.fecha_visita DESC, sv.hora_visita DESC";

        List<SolicitudVisita> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idCliente);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }
        return lista;
    }

    /**
     * Lista las solicitudes recibidas para los inmuebles de una inmobiliaria.
     *
     * @param idInmobiliaria ID del usuario (INMOBILIARIA) dueño de las propiedades
     * @return Lista de solicitudes, priorizando las PENDIENTES
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<SolicitudVisita> listarPorInmobiliaria(int idInmobiliaria) throws SQLException {
        String sql = SELECT_BASE
                + "WHERE p.id_inmobiliaria = ? "
                + "ORDER BY FIELD(sv.estado, 'PENDIENTE', 'CONFIRMADA', 'REALIZADA', 'CANCELADA'), "
                + "sv.fecha_visita ASC, sv.hora_visita ASC";

        List<SolicitudVisita> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idInmobiliaria);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }
        return lista;
    }

    /**
     * Obtiene una solicitud por su clave primaria.
     *
     * @param idSolicitud ID de la solicitud
     * @return Solicitud encontrada o null si no existe
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public SolicitudVisita obtenerPorId(int idSolicitud) throws SQLException {
        String sql = SELECT_BASE + "WHERE sv.id_solicitud = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idSolicitud);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        }
        return null;
    }

    /**
     * Actualiza el estado de una solicitud.
     *
     * @param idSolicitud ID de la solicitud
     * @param nuevoEstado 'PENDIENTE', 'CONFIRMADA', 'CANCELADA' o 'REALIZADA'
     * @return true si se actualizo al menos un registro
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public boolean cambiarEstado(int idSolicitud, String nuevoEstado) throws SQLException {
        String sql = "UPDATE solicitud_visita SET estado = ? WHERE id_solicitud = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nuevoEstado);
            ps.setInt(2, idSolicitud);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Mapea la fila actual del ResultSet a un objeto SolicitudVisita.
     */
    private SolicitudVisita mapear(ResultSet rs) throws SQLException {
        SolicitudVisita s = new SolicitudVisita();
        s.setIdSolicitud(rs.getInt("id_solicitud"));
        s.setIdPropiedad(rs.getInt("id_propiedad"));
        s.setIdCliente(rs.getInt("id_cliente"));

        java.sql.Date fecha = rs.getDate("fecha_visita");
        if (fecha != null) {
            s.setFechaVisita(fecha.toLocalDate());
        }

        java.sql.Time hora = rs.getTime("hora_visita");
        if (hora != null) {
            s.setHoraVisita(hora.toLocalTime());
        }

        s.setComentario(rs.getString("comentario"));
        s.setEstado(rs.getString("estado"));

        java.sql.Timestamp creacion = rs.getTimestamp("fecha_creacion");
        if (creacion != null) {
            s.setFechaCreacion(creacion.toLocalDateTime());
        }

        s.setTituloPropiedad(rs.getString("titulo_propiedad"));
        s.setNombreCliente(rs.getString("nombre_cliente"));
        s.setCorreoCliente(rs.getString("correo_cliente"));
        s.setIdInmobiliaria(rs.getInt("id_inmobiliaria"));
        return s;
    }
}
