package com.inmobiliaria.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Entidad POJO que representa un documento radicado dentro de una solicitud
 * de compra o arriendo. Mapea la tabla 'documento_solicitud'.
 */
public class DocumentoSolicitud implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idDocumento;
    private int idSolicitud;
    private String tipo;          // CEDULA | INGRESOS | ESCRITURA | ...
    private String nombre;
    private String urlDocumento;
    private LocalDateTime fechaCarga;

    public DocumentoSolicitud() {
    }

    public int getIdDocumento() {
        return idDocumento;
    }

    public void setIdDocumento(int idDocumento) {
        this.idDocumento = idDocumento;
    }

    public int getIdSolicitud() {
        return idSolicitud;
    }

    public void setIdSolicitud(int idSolicitud) {
        this.idSolicitud = idSolicitud;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getUrlDocumento() {
        return urlDocumento;
    }

    public void setUrlDocumento(String urlDocumento) {
        this.urlDocumento = urlDocumento;
    }

    public LocalDateTime getFechaCarga() {
        return fechaCarga;
    }

    public void setFechaCarga(LocalDateTime fechaCarga) {
        this.fechaCarga = fechaCarga;
    }

    @Override
    public String toString() {
        return "DocumentoSolicitud{id=" + idDocumento + ", nombre='" + nombre + "'}";
    }
}
