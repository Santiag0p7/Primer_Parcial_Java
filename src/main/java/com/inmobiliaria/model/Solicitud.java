package com.inmobiliaria.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entidad POJO que representa una solicitud (tramite) de compra o arriendo
 * radicada por un cliente sobre una propiedad.
 * Mapea la tabla 'solicitud' y sus datos auxiliares de JOIN para las vistas.
 */
public class Solicitud implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idSolicitud;
    private int idPropiedad;
    private int idCliente;
    private String tipo;              // COMPRA | ARRIENDO
    private BigDecimal montoOferta;
    private String mensaje;
    private String estado;            // PENDIENTE | EN_REVISION | APROBADA | RECHAZADA | CANCELADA
    private String observacion;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaActualizacion;

    // Campos auxiliares (JOIN)
    private String tituloPropiedad;
    private String nombreCliente;
    private String correoCliente;
    private String nombreCiudad;
    private int idInmobiliaria;

    public Solicitud() {
    }

    public int getIdSolicitud() {
        return idSolicitud;
    }

    public void setIdSolicitud(int idSolicitud) {
        this.idSolicitud = idSolicitud;
    }

    public int getIdPropiedad() {
        return idPropiedad;
    }

    public void setIdPropiedad(int idPropiedad) {
        this.idPropiedad = idPropiedad;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public BigDecimal getMontoOferta() {
        return montoOferta;
    }

    public void setMontoOferta(BigDecimal montoOferta) {
        this.montoOferta = montoOferta;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    public LocalDateTime getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(LocalDateTime fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public LocalDateTime getFechaActualizacion() {
        return fechaActualizacion;
    }

    public void setFechaActualizacion(LocalDateTime fechaActualizacion) {
        this.fechaActualizacion = fechaActualizacion;
    }

    public String getTituloPropiedad() {
        return tituloPropiedad;
    }

    public void setTituloPropiedad(String tituloPropiedad) {
        this.tituloPropiedad = tituloPropiedad;
    }

    public String getNombreCliente() {
        return nombreCliente;
    }

    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
    }

    public String getCorreoCliente() {
        return correoCliente;
    }

    public void setCorreoCliente(String correoCliente) {
        this.correoCliente = correoCliente;
    }

    public String getNombreCiudad() {
        return nombreCiudad;
    }

    public void setNombreCiudad(String nombreCiudad) {
        this.nombreCiudad = nombreCiudad;
    }

    public int getIdInmobiliaria() {
        return idInmobiliaria;
    }

    public void setIdInmobiliaria(int idInmobiliaria) {
        this.idInmobiliaria = idInmobiliaria;
    }

    @Override
    public String toString() {
        return "Solicitud{id=" + idSolicitud + ", tipo='" + tipo + "', estado='" + estado + "'}";
    }
}
