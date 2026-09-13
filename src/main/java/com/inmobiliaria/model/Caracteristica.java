package com.inmobiliaria.model;

import java.io.Serializable;

/**
 * Entidad POJO que representa una caracteristica de una propiedad.
 * Mapea la tabla 'caracteristica' y participa en la relacion N:M
 * con 'propiedad' a traves de 'propiedad_caracteristica'.
 */
public class Caracteristica implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idCaracteristica;
    private String nombre;

    // Constructor vacio
    public Caracteristica() {
    }

    // Constructor completo
    public Caracteristica(int idCaracteristica, String nombre) {
        this.idCaracteristica = idCaracteristica;
        this.nombre = nombre;
    }

    // Getters y Setters
    public int getIdCaracteristica() {
        return idCaracteristica;
    }

    public void setIdCaracteristica(int idCaracteristica) {
        this.idCaracteristica = idCaracteristica;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    @Override
    public String toString() {
        return "Caracteristica{id=" + idCaracteristica + ", nombre='" + nombre + "'}";
    }
}
