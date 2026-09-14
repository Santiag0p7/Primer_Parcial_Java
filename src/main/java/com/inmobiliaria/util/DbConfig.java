package com.inmobiliaria.util;

import java.util.Properties;

/**
 * Fuente unica de configuracion de la base de datos (Sprint 3 - cierre).
 *
 * Los valores se extraen al arrancar la aplicacion desde el archivo
 * /conexion.jspf (raiz del proyecto) mediante AppConfigListener, y quedan
 * disponibles para toda la capa Java (DAO / ConexionDB). El mismo archivo
 * es usado por los JSP, de modo que existe UN SOLO lugar que editar para
 * cambiar entre una base de datos local o en linea.
 */
public final class DbConfig {

    private static final Properties PROPS = new Properties();
    private static volatile boolean cargado = false;

    private DbConfig() {
    }

    /**
     * Carga (o recarga) la configuracion con las propiedades indicadas.
     *
     * @param props propiedades con claves db.host, db.port, db.name, etc.
     */
    public static synchronized void cargar(Properties props) {
        if (props == null) {
            return;
        }
        PROPS.clear();
        PROPS.putAll(props);
        cargado = true;
    }

    /**
     * Obtiene un valor de configuracion.
     *
     * @param clave clave de la propiedad (por ejemplo "db.host")
     * @return valor configurado, o null si no existe / no se ha cargado
     */
    public static String obtener(String clave) {
        return cargado ? PROPS.getProperty(clave) : null;
    }

    /**
     * Indica si la configuracion ya fue cargada desde conexion.jspf.
     */
    public static boolean isCargado() {
        return cargado;
    }
}
