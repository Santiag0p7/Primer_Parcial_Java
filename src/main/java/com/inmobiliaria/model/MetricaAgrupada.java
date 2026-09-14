package com.inmobiliaria.model;

import java.io.Serializable;

/**
 * POJO de resultado generico para consultas de agregacion del dashboard
 * (Sprint 3 - Item 3). Representa una fila "etiqueta + total" producida por
 * un GROUP BY (por ciudad, por tipo de propiedad, etc.).
 */
public class MetricaAgrupada implements Serializable {

    private static final long serialVersionUID = 1L;

    private String etiqueta;
    private int total;

    public MetricaAgrupada() {
    }

    public MetricaAgrupada(String etiqueta, int total) {
        this.etiqueta = etiqueta;
        this.total = total;
    }

    public String getEtiqueta() {
        return etiqueta;
    }

    public void setEtiqueta(String etiqueta) {
        this.etiqueta = etiqueta;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    @Override
    public String toString() {
        return "MetricaAgrupada{etiqueta='" + etiqueta + "', total=" + total + "}";
    }
}
