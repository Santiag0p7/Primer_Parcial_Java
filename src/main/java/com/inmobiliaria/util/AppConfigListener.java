package com.inmobiliaria.util;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Listener que carga la configuracion de la base de datos al arrancar la
 * aplicacion. Lee el archivo /conexion.jspf (raiz del proyecto), extrae las
 * variables DB_HOST, DB_PORT, DB_NOMBRE, DB_USUARIO y DB_PASS y las entrega a
 * DbConfig, que consume ConexionDB (y por ende todos los DAO).
 *
 * De este modo, conexion.jspf es el UNICO archivo a editar para cambiar entre
 * una base de datos local o en linea, tanto para los JSP como para Java.
 *
 * Si el archivo no existe o falla, la aplicacion continua con los valores por
 * defecto / variables de entorno, sin romper el arranque.
 */
public class AppConfigListener implements ServletContextListener {

    private static final String ARCHIVO_CONFIG = "/conexion.jspf";

    // Patrones ancorados al inicio de linea para ignorar las lineas comentadas
    private static final Pattern P_HOST   = patron("String", "DB_HOST");
    private static final Pattern P_PORT   = patron("int", "DB_PORT");
    private static final Pattern P_NOMBRE = patron("String", "DB_NOMBRE");
    private static final Pattern P_USUARIO = patron("String", "DB_USUARIO");
    private static final Pattern P_PASS   = patron("String", "DB_PASS");

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();

        try (InputStream in = ctx.getResourceAsStream(ARCHIVO_CONFIG)) {
            if (in != null) {
                DbConfig.cargar(leerConfiguracion(in));
                ctx.log("UTS Inmobiliaria: configuracion de BD cargada desde " + ARCHIVO_CONFIG);
            } else {
                ctx.log("UTS Inmobiliaria: no se encontro " + ARCHIVO_CONFIG
                        + ". Se usaran valores por defecto/variables de entorno.");
            }
        } catch (IOException e) {
            ctx.log("UTS Inmobiliaria: error al leer " + ARCHIVO_CONFIG, e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Sin recursos que liberar
    }

    /**
     * Lee el contenido del fragmento y construye las propiedades de conexion.
     */
    private Properties leerConfiguracion(InputStream in) throws IOException {
        String contenido = leerTexto(in);

        Properties props = new Properties();
        poner(props, "db.host", extraer(contenido, P_HOST));
        poner(props, "db.port", extraer(contenido, P_PORT));
        poner(props, "db.name", extraer(contenido, P_NOMBRE));
        poner(props, "db.user", extraer(contenido, P_USUARIO));
        poner(props, "db.password", extraer(contenido, P_PASS));
        return props;
    }

    /**
     * Construye un patron tipo: ^\s*<tipo>\s+<var>\s*=\s*(numero|"texto")
     */
    private static Pattern patron(String tipo, String variable) {
        String valor = "int".equals(tipo) ? "(\\d+)" : "\"([^\"]*)\"";
        return Pattern.compile(
                "^\\s*" + tipo + "\\s+" + variable + "\\s*=\\s*" + valor,
                Pattern.MULTILINE);
    }

    private static String extraer(String texto, Pattern patron) {
        Matcher m = patron.matcher(texto);
        return m.find() ? m.group(1) : null;
    }

    private static void poner(Properties props, String clave, String valor) {
        if (valor != null) {
            props.setProperty(clave, valor);
        }
    }

    private static String leerTexto(InputStream in) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(in, StandardCharsets.UTF_8))) {
            char[] buffer = new char[4096];
            int leidos;
            while ((leidos = br.read(buffer)) != -1) {
                sb.append(buffer, 0, leidos);
            }
        }
        return sb.toString();
    }
}
