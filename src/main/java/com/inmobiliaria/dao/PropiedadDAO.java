package com.inmobiliaria.dao;

import com.inmobiliaria.model.Propiedad;
import com.inmobiliaria.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO (Data Access Object) para la entidad Propiedad.
 * Implementa las operaciones JDBC contra la tabla 'propiedad',
 * usando siempre PreparedStatement para prevenir SQL Injection.
 *
 * Requisito clave del parcial:
 *   - La eliminacion es LOGICA (bajaLogica), nunca fisica.
 *   - insertar() y actualizar() propagan SQLException para que el
 *     controlador valide la restriccion UNIQUE de matricula_inmobiliaria.
 */
public class PropiedadDAO {

    // SELECT base con JOIN a los catalogos para traer nombre de tipo y ciudad
    private static final String SELECT_BASE =
            "SELECT p.id_propiedad, p.matricula_inmobiliaria, p.titulo, p.descripcion, "
          + "p.precio, p.habitaciones, p.banos, p.area_m2, p.direccion, p.estado_logico, "
          + "p.id_inmobiliaria, p.id_tipo, p.id_ciudad, p.fecha_publicacion, "
          + "t.nombre AS nombre_tipo, c.nombre AS nombre_ciudad "
          + "FROM propiedad p "
          + "INNER JOIN tipo_propiedad t ON p.id_tipo = t.id_tipo "
          + "INNER JOIN ciudad c ON p.id_ciudad = c.id_ciudad ";

    /**
     * Lista todas las propiedades activas (estado_logico = TRUE).
     *
     * @return Lista de propiedades activas ordenadas por fecha descendente
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<Propiedad> listarTodasActivas() throws SQLException {
        String sql = SELECT_BASE + "WHERE p.estado_logico = TRUE ORDER BY p.fecha_publicacion DESC";

        List<Propiedad> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapear(rs));
            }
        }
        return lista;
    }

    /**
     * Lista las propiedades activas pertenecientes a una inmobiliaria.
     *
     * @param idInmobiliaria ID del usuario con rol INMOBILIARIA
     * @return Lista de propiedades activas de esa inmobiliaria
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<Propiedad> listarPorInmobiliaria(int idInmobiliaria) throws SQLException {
        String sql = SELECT_BASE
                + "WHERE p.estado_logico = TRUE AND p.id_inmobiliaria = ? "
                + "ORDER BY p.fecha_publicacion DESC";

        List<Propiedad> lista = new ArrayList<>();

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
     * Obtiene una propiedad por su clave primaria, sin importar su estado.
     *
     * @param id ID de la propiedad
     * @return Propiedad encontrada o null si no existe
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public Propiedad obtenerPorId(int id) throws SQLException {
        String sql = SELECT_BASE + "WHERE p.id_propiedad = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        }
        return null;
    }

    /**
     * Inserta una nueva propiedad.
     * Propaga SQLException para que el controlador detecte
     * la violacion de la restriccion UNIQUE (matricula_inmobiliaria).
     *
     * @param p Propiedad a insertar
     * @return true si se inserto correctamente
     * @throws SQLException si ocurre un error (incluye duplicados UNIQUE)
     */
    public boolean insertar(Propiedad p) throws SQLException {
        return insertarYRetornarId(p) > 0;
    }

    /**
     * Inserta una nueva propiedad y retorna el ID generado.
     * Necesario para asociar caracteristicas (N:M) e imagenes (1:N)
     * en el mismo flujo de registro.
     *
     * @param p Propiedad a insertar
     * @return ID generado, o -1 si no se pudo obtener
     * @throws SQLException si ocurre un error (incluye duplicados UNIQUE)
     */
    public int insertarYRetornarId(Propiedad p) throws SQLException {
        try (Connection conn = ConexionDB.obtenerConexion()) {
            return insertarYRetornarId(conn, p);
        }
    }

    /**
     * Variante que recibe una conexion existente para participar en una
     * transaccion coordinada por la capa controladora. NO cierra la conexion.
     *
     * @param conn Conexion JDBC suministrada por el llamador
     * @param p    Propiedad a insertar
     * @return ID generado, o -1 si no se pudo obtener
     * @throws SQLException si ocurre un error (incluye duplicados UNIQUE)
     */
    public int insertarYRetornarId(Connection conn, Propiedad p) throws SQLException {
        String sql = "INSERT INTO propiedad "
                + "(matricula_inmobiliaria, titulo, descripcion, precio, habitaciones, banos, "
                + "area_m2, direccion, estado_logico, id_inmobiliaria, id_tipo, id_ciudad, fecha_publicacion) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, TRUE, ?, ?, ?, NOW())";

        try (PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, p.getMatriculaInmobiliaria());
            ps.setString(2, p.getTitulo());
            ps.setString(3, p.getDescripcion());
            ps.setBigDecimal(4, p.getPrecio());
            ps.setInt(5, p.getHabitaciones());
            ps.setInt(6, p.getBanos());
            ps.setBigDecimal(7, p.getAreaM2());
            ps.setString(8, p.getDireccion());
            ps.setInt(9, p.getIdInmobiliaria());
            ps.setInt(10, p.getIdTipo());
            ps.setInt(11, p.getIdCiudad());

            if (ps.executeUpdate() == 0) {
                return -1;
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            return -1;
        }
    }

    /**
     * Actualiza los campos de una propiedad existente.
     * Propaga SQLException para validar la restriccion UNIQUE.
     *
     * @param p Propiedad con los datos actualizados (debe incluir idPropiedad)
     * @return true si se actualizo al menos un registro
     * @throws SQLException si ocurre un error (incluye duplicados UNIQUE)
     */
    public boolean actualizar(Propiedad p) throws SQLException {
        try (Connection conn = ConexionDB.obtenerConexion()) {
            return actualizar(conn, p);
        }
    }

    /**
     * Variante que recibe una conexion existente para participar en una
     * transaccion coordinada por la capa controladora. NO cierra la conexion.
     *
     * @param conn Conexion JDBC suministrada por el llamador
     * @param p    Propiedad con los datos actualizados (debe incluir idPropiedad)
     * @return true si se actualizo al menos un registro
     * @throws SQLException si ocurre un error (incluye duplicados UNIQUE)
     */
    public boolean actualizar(Connection conn, Propiedad p) throws SQLException {
        String sql = "UPDATE propiedad SET "
                + "matricula_inmobiliaria = ?, titulo = ?, descripcion = ?, precio = ?, "
                + "habitaciones = ?, banos = ?, area_m2 = ?, direccion = ?, "
                + "id_tipo = ?, id_ciudad = ? "
                + "WHERE id_propiedad = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getMatriculaInmobiliaria());
            ps.setString(2, p.getTitulo());
            ps.setString(3, p.getDescripcion());
            ps.setBigDecimal(4, p.getPrecio());
            ps.setInt(5, p.getHabitaciones());
            ps.setInt(6, p.getBanos());
            ps.setBigDecimal(7, p.getAreaM2());
            ps.setString(8, p.getDireccion());
            ps.setInt(9, p.getIdTipo());
            ps.setInt(10, p.getIdCiudad());
            ps.setInt(11, p.getIdPropiedad());

            return ps.executeUpdate() > 0;
        }
    }

    /**
     * REQUISITO OBLIGATORIO DEL PARCIAL.
     * Realiza la baja logica de una propiedad (no se borra fisicamente).
     * UPDATE propiedad SET estado_logico = FALSE WHERE id_propiedad = ?
     *
     * @param idPropiedad ID de la propiedad a desactivar
     * @return true si se desactivo correctamente
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public boolean bajaLogica(int idPropiedad) throws SQLException {
        String sql = "UPDATE propiedad SET estado_logico = FALSE WHERE id_propiedad = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idPropiedad);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lista TODAS las propiedades (activas e inactivas) con el correo de la
     * inmobiliaria duena. Uso exclusivo del panel de administracion.
     *
     * @param filtro "activas", "inactivas" o cualquier otro valor para todas
     * @return Lista de propiedades ordenadas por fecha descendente
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<Propiedad> listarTodasAdmin(String filtro) throws SQLException {
        StringBuilder sql = new StringBuilder();

        // Incluye el correo del dueno (inmobiliaria) ademas de tipo y ciudad.
        sql.append("SELECT p.id_propiedad, p.matricula_inmobiliaria, p.titulo, p.descripcion, ")
           .append("p.precio, p.habitaciones, p.banos, p.area_m2, p.direccion, p.estado_logico, ")
           .append("p.id_inmobiliaria, p.id_tipo, p.id_ciudad, p.fecha_publicacion, ")
           .append("t.nombre AS nombre_tipo, c.nombre AS nombre_ciudad, ")
           .append("u.correo AS correo_inmobiliaria ")
           .append("FROM propiedad p ")
           .append("INNER JOIN tipo_propiedad t ON p.id_tipo = t.id_tipo ")
           .append("INNER JOIN ciudad c ON p.id_ciudad = c.id_ciudad ")
           .append("INNER JOIN usuario u ON p.id_inmobiliaria = u.id_usuario ");

        if ("activas".equals(filtro)) {
            sql.append("WHERE p.estado_logico = TRUE ");
        } else if ("inactivas".equals(filtro)) {
            sql.append("WHERE p.estado_logico = FALSE ");
        }

        sql.append("ORDER BY p.fecha_publicacion DESC");

        List<Propiedad> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql.toString());
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Propiedad p = mapear(rs);
                p.setCorreoInmobiliaria(rs.getString("correo_inmobiliaria"));
                lista.add(p);
            }
        }
        return lista;
    }

    /**
     * Activa o desactiva (baja logica) una propiedad. Uso del administrador.
     *
     * @param idPropiedad ID de la propiedad
     * @param activo true = activa, false = desactivada
     * @return true si se actualizo correctamente
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public boolean cambiarEstadoLogico(int idPropiedad, boolean activo) throws SQLException {
        String sql = "UPDATE propiedad SET estado_logico = ? WHERE id_propiedad = ?";

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, activo);
            ps.setInt(2, idPropiedad);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lista el catalogo de tipos de propiedad para los selectores del formulario.
     *
     * @return Mapa id_tipo -> nombre
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public java.util.Map<Integer, String> listarTipos() throws SQLException {
        String sql = "SELECT id_tipo, nombre FROM tipo_propiedad ORDER BY nombre";
        java.util.Map<Integer, String> tipos = new java.util.LinkedHashMap<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                tipos.put(rs.getInt("id_tipo"), rs.getString("nombre"));
            }
        }
        return tipos;
    }

    /**
     * Lista el catalogo de ciudades para los selectores del formulario.
     *
     * @return Mapa id_ciudad -> nombre
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public java.util.Map<Integer, String> listarCiudades() throws SQLException {
        String sql = "SELECT id_ciudad, nombre FROM ciudad ORDER BY nombre";
        java.util.Map<Integer, String> ciudades = new java.util.LinkedHashMap<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ciudades.put(rs.getInt("id_ciudad"), rs.getString("nombre"));
            }
        }
        return ciudades;
    }

    /**
     * Busca propiedades activas aplicando filtros dinamicos opcionales.
     * Construye la clausula WHERE dinamicamente con PreparedStatement,
     * garantizando que los valores siempre vayan parametrizados.
     *
     * @param idCiudad  Filtro por ciudad (0 o null = sin filtro)
     * @param idTipo    Filtro por tipo (0 o null = sin filtro)
     * @param precioMin Precio minimo (null = sin filtro)
     * @param precioMax Precio maximo (null = sin filtro)
     * @param palabra   Palabra clave en titulo/descripcion (null o vacio = sin filtro)
     * @param idCaracteristica Filtro por caracteristica N:M (0 o null = sin filtro)
     * @return Lista de propiedades activas que cumplen los filtros
     * @throws SQLException si ocurre un error de acceso a datos
     */
    public List<Propiedad> buscarConFiltros(Integer idCiudad, Integer idTipo,
                                            java.math.BigDecimal precioMin,
                                            java.math.BigDecimal precioMax,
                                            String palabra,
                                            Integer idCaracteristica) throws SQLException {

        StringBuilder sql = new StringBuilder(SELECT_BASE);
        sql.append("WHERE p.estado_logico = TRUE ");

        List<Object> parametros = new ArrayList<>();

        if (idCiudad != null && idCiudad > 0) {
            sql.append("AND p.id_ciudad = ? ");
            parametros.add(idCiudad);
        }
        if (idTipo != null && idTipo > 0) {
            sql.append("AND p.id_tipo = ? ");
            parametros.add(idTipo);
        }
        if (precioMin != null) {
            sql.append("AND p.precio >= ? ");
            parametros.add(precioMin);
        }
        if (precioMax != null) {
            sql.append("AND p.precio <= ? ");
            parametros.add(precioMax);
        }
        if (palabra != null && !palabra.trim().isEmpty()) {
            sql.append("AND (p.titulo LIKE ? OR p.descripcion LIKE ?) ");
            String like = "%" + palabra.trim() + "%";
            parametros.add(like);
            parametros.add(like);
        }
        if (idCaracteristica != null && idCaracteristica > 0) {
            sql.append("AND EXISTS (SELECT 1 FROM propiedad_caracteristica pc ")
               .append("WHERE pc.id_propiedad = p.id_propiedad AND pc.id_caracteristica = ?) ");
            parametros.add(idCaracteristica);
        }

        sql.append("ORDER BY p.fecha_publicacion DESC");

        List<Propiedad> lista = new ArrayList<>();

        try (Connection conn = ConexionDB.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < parametros.size(); i++) {
                ps.setObject(i + 1, parametros.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }
        return lista;
    }

    /**
     * Mapea la fila actual del ResultSet a un objeto Propiedad.
     */
    private Propiedad mapear(ResultSet rs) throws SQLException {
        Propiedad p = new Propiedad();
        p.setIdPropiedad(rs.getInt("id_propiedad"));
        p.setMatriculaInmobiliaria(rs.getString("matricula_inmobiliaria"));
        p.setTitulo(rs.getString("titulo"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setPrecio(rs.getBigDecimal("precio"));
        p.setHabitaciones(rs.getInt("habitaciones"));
        p.setBanos(rs.getInt("banos"));
        p.setAreaM2(rs.getBigDecimal("area_m2"));
        p.setDireccion(rs.getString("direccion"));
        p.setEstadoLogico(rs.getBoolean("estado_logico"));
        p.setIdInmobiliaria(rs.getInt("id_inmobiliaria"));
        p.setIdTipo(rs.getInt("id_tipo"));
        p.setIdCiudad(rs.getInt("id_ciudad"));

        java.sql.Timestamp fecha = rs.getTimestamp("fecha_publicacion");
        if (fecha != null) {
            p.setFechaPublicacion(fecha.toLocalDateTime());
        }

        p.setNombreTipo(rs.getString("nombre_tipo"));
        p.setNombreCiudad(rs.getString("nombre_ciudad"));
        return p;
    }
}
