package com.inmobiliaria.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utilidad de conexion a la base de datos MySQL/MariaDB.
 * La configuracion esta definida en includes/conexion.jspf.
 * Esta clase es usada por los DAOs para obtener conexiones JDBC.
 */
public class ConexionDB {

    // Carga el driver JDBC una sola vez al cargar la clase
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Error: No se encontro el driver JDBC de MySQL.", e);
        }
    }

    /**
     * Obtiene una conexion nueva a la base de datos.
     * Los parametros deben coincidir con los de includes/conexion.jspf.
     *
     * @return Conexion JDBC activa
     * @throws SQLException si no se puede conectar
     */
    public static Connection obtenerConexion() throws SQLException {
        String host   = "localhost";
        int    port   = 3306;
        String db     = "inmobiliaria";
        String user   = "root";
        String pass   = "";

        String url = "jdbc:mysql://" + host + ":" + port
                + "/" + db
                + "?useSSL=false&serverTimezone=America/Bogota&allowPublicKeyRetrieval=true";

        return DriverManager.getConnection(url, user, pass);
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
