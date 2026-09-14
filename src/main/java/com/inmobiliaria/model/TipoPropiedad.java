package com.inmobiliaria.model;

import java.io.Serializable;

/**
 * Entidad POJO que representa un tipo de propiedad del catalogo.
 * Mapea la tabla 'tipo_propiedad' (Sprint 3 - Item 2: parametros administrables).
 */
public class TipoPropiedad implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idTipo;
    private String nombre;

    public TipoPropiedad() {
    }

    public TipoPropiedad(int idTipo, String nombre) {
        this.idTipo = idTipo;
        this.nombre = nombre;
    }

    public int getIdTipo() {
        return idTipo;
    }

    public void setIdTipo(int idTipo) {
        this.idTipo = idTipo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    @Override
    public String toString() {
        return "TipoPropiedad{id=" + idTipo + ", nombre='" + nombre + "'}";
    }
}
