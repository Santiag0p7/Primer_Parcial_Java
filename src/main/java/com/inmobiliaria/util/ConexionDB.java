package com.inmobiliaria.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utilidad de conexion a la base de datos MySQL/MariaDB.
 *
 * La configuracion es externa y configurable. Cada parametro se resuelve en
 * este orden de prioridad:
 *   1. Archivo /conexion.jspf (raiz, cargado por AppConfigListener)
 *   2. Propiedad del sistema JVM  -> -Ddb.host=localhost
 *   3. Variable de entorno        -> DB_HOST=localhost
 *   4. Valor por defecto (XAMPP)  -> localhost / 3306 / inmobiliaria / root / (sin password)
 *
 * Editar el conexion.jspf de la raiz es suficiente para cambiar entre una base
 * de datos local o en linea, sin recompilar ni tocar el resto del codigo.
 */
public class ConexionDB {

    // Nombres de las propiedades/variables configurables
    private static final String PROP_HOST = "db.host";
    private static final String PROP_PORT = "db.port";
    private static final String PROP_NAME = "db.name";
    private static final String PROP_USER = "db.user";
    private static final String PROP_PASS = "db.password";

    // Valores por defecto (entorno XAMPP)
    private static final String DEFAULT_HOST = "localhost";
    private static final String DEFAULT_PORT = "3306";
    private static final String DEFAULT_NAME = "inmobiliaria";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASS = "";

    // Carga el driver JDBC una sola vez al cargar la clase
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Error: No se encontro el driver JDBC de MySQL.", e);
        }
    }

    /**
     * Obtiene una conexion nueva a la base de datos usando la configuracion
     * resuelta desde conexion.jspf, propiedades del sistema, variables de
     * entorno o los valores por defecto.
     *
     * @return Conexion JDBC activa
     * @throws SQLException si no se puede conectar
     */
    public static Connection obtenerConexion() throws SQLException {
        String host = getConfig(PROP_HOST, "DB_HOST", DEFAULT_HOST);
        String port = getConfig(PROP_PORT, "DB_PORT", DEFAULT_PORT);
        String db   = getConfig(PROP_NAME, "DB_NAME", DEFAULT_NAME);
        String user = getConfig(PROP_USER, "DB_USER", DEFAULT_USER);
        String pass = getConfig(PROP_PASS, "DB_PASSWORD", DEFAULT_PASS);

        String url = "jdbc:mysql://" + host + ":" + port
                + "/" + db
                + "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";

        return DriverManager.getConnection(url, user, pass);
    }

    /**
     * Resuelve un valor de configuracion aplicando la prioridad
     * conexion.jspf > propiedad del sistema > variable de entorno > valor por defecto.
     */
    private static String getConfig(String clave, String envVariable, String defaultValue) {
        String value = DbConfig.obtener(clave); // 1) /conexion.jspf (raiz)

        if (value == null || value.trim().isEmpty()) {
            value = System.getProperty(clave); // 2) -Dclave=valor
        }

        if (value == null || value.trim().isEmpty()) {
            value = System.getenv(envVariable); // 3) variable de entorno
        }

        return (value == null || value.trim().isEmpty()) ? defaultValue : value; // 4) default
    }

    /**
     * Cierra silenciosamente una conexion.
     */
    public static void cerrar(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException ignored) {
            }
        }
    }
}
