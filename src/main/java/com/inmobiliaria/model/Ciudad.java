package com.inmobiliaria.model;

import java.io.Serializable;

/**
 * Entidad POJO que representa una ciudad del catalogo.
 * Mapea la tabla 'ciudad' (Sprint 3 - Item 2: parametros administrables).
 */
public class Ciudad implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idCiudad;
    private String nombre;
    private String departamento;

    public Ciudad() {
    }

    public Ciudad(int idCiudad, String nombre, String departamento) {
        this.idCiudad = idCiudad;
        this.nombre = nombre;
        this.departamento = departamento;
    }

    public int getIdCiudad() {
        return idCiudad;
    }

    public void setIdCiudad(int idCiudad) {
        this.idCiudad = idCiudad;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDepartamento() {
        return departamento;
    }

    public void setDepartamento(String departamento) {
        this.departamento = departamento;
    }

    @Override
    public String toString() {
        return "Ciudad{id=" + idCiudad + ", nombre='" + nombre
                + "', departamento='" + departamento + "'}";
    }
}
