package com.inmobiliaria.model;

import java.io.Serializable;

/**
 * POJO de resultado para el reporte de agregacion de propiedades por ciudad.
 * Alimenta la consulta GROUP BY ... HAVING del modulo de reportes.
 */
public class ConteoCiudad implements Serializable {

    private static final long serialVersionUID = 1L;

    private String nombreCiudad;
    private int total;

    public ConteoCiudad() {
    }

    public String getNombreCiudad() {
        return nombreCiudad;
    }

    public void setNombreCiudad(String nombreCiudad) {
        this.nombreCiudad = nombreCiudad;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    @Override
    public String toString() {
        return "ConteoCiudad{ciudad='" + nombreCiudad + "', total=" + total + "}";
    }
}
