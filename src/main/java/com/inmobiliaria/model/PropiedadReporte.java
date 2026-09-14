package com.inmobiliaria.model;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * POJO de resultado para el reporte que cruza una propiedad con su tipo,
 * su ciudad y la inmobiliaria (usuario) que la publico.
 *
 * Alimenta la consulta INNER JOIN entre cuatro tablas del modulo de reportes.
 */
public class PropiedadReporte implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idPropiedad;
    private String titulo;
    private BigDecimal precio;
    private String nombreTipo;
    private String nombreCiudad;
    private String correoInmobiliaria;

    public PropiedadReporte() {
    }

    public int getIdPropiedad() {
        return idPropiedad;
    }

    public void setIdPropiedad(int idPropiedad) {
        this.idPropiedad = idPropiedad;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public BigDecimal getPrecio() {
        return precio;
    }

    public void setPrecio(BigDecimal precio) {
        this.precio = precio;
    }

    public String getNombreTipo() {
        return nombreTipo;
    }

    public void setNombreTipo(String nombreTipo) {
        this.nombreTipo = nombreTipo;
    }

    public String getNombreCiudad() {
        return nombreCiudad;
    }

    public void setNombreCiudad(String nombreCiudad) {
        this.nombreCiudad = nombreCiudad;
    }

    public String getCorreoInmobiliaria() {
        return correoInmobiliaria;
    }

    public void setCorreoInmobiliaria(String correoInmobiliaria) {
        this.correoInmobiliaria = correoInmobiliaria;
    }

    @Override
    public String toString() {
        return "PropiedadReporte{id=" + idPropiedad + ", titulo='" + titulo
                + "', tipo='" + nombreTipo + "', ciudad='" + nombreCiudad
                + "', inmobiliaria='" + correoInmobiliaria + "'}";
    }
}
