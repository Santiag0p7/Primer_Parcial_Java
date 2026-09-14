package com.inmobiliaria.model;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

/**
 * Entidad POJO que representa la solicitud de visita (cita) de un cliente
 * sobre una propiedad. Mapea la tabla 'solicitud_visita' (Sprint 3 - Item 1).
 *
 * Ademas de las columnas de la tabla incluye campos auxiliares (producto de
 * los JOIN del DAO) para mostrar informacion legible en las vistas.
 */
public class SolicitudVisita implements Serializable {

    private static final long serialVersionUID = 1L;

    // Columnas de la tabla 'solicitud_visita'
    private int idSolicitud;
    private int idPropiedad;
    private int idCliente;
    private LocalDate fechaVisita;
    private LocalTime horaVisita;
    private String comentario;
    private String estado;
    private LocalDateTime fechaCreacion;

    // Campos auxiliares para las vistas (JOIN)
    private String tituloPropiedad;
    private String nombreCliente;
    private String correoCliente;
    private int idInmobiliaria; // Duena de la propiedad (control de acceso)

    public SolicitudVisita() {
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

    public LocalDate getFechaVisita() {
        return fechaVisita;
    }

    public void setFechaVisita(LocalDate fechaVisita) {
        this.fechaVisita = fechaVisita;
    }

    public LocalTime getHoraVisita() {
        return horaVisita;
    }

    public void setHoraVisita(LocalTime horaVisita) {
        this.horaVisita = horaVisita;
    }

    public String getComentario() {
        return comentario;
    }

    public void setComentario(String comentario) {
        this.comentario = comentario;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public LocalDateTime getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(LocalDateTime fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
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

    public int getIdInmobiliaria() {
        return idInmobiliaria;
    }

    public void setIdInmobiliaria(int idInmobiliaria) {
        this.idInmobiliaria = idInmobiliaria;
    }

    @Override
    public String toString() {
        return "SolicitudVisita{id=" + idSolicitud + ", idPropiedad=" + idPropiedad
                + ", idCliente=" + idCliente + ", fecha=" + fechaVisita
                + ", hora=" + horaVisita + ", estado='" + estado + "'}";
    }
}
