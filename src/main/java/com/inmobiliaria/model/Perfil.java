package com.inmobiliaria.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Entidad POJO que representa el perfil de un usuario del sistema.
 * Mapea la tabla 'perfil' de la base de datos inmobiliaria.
 *
 * La relacion usuario <-> perfil es 1:1, garantizada por la restriccion
 * UNIQUE de la columna 'id_usuario' en la tabla 'perfil'.
 */
public class Perfil implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idPerfil;
    private int idUsuario;
    private String nombres;
    private String apellidos;
    private String documento;
    private String telefono;
    private String direccion;
    private String fotoUrl;
    private LocalDateTime fechaActualizacion;

    // Constructor vacio
    public Perfil() {
    }

    // Constructor completo
    public Perfil(int idPerfil, int idUsuario, String nombres, String apellidos,
                  String documento, String telefono, String direccion,
                  LocalDateTime fechaActualizacion) {
        this.idPerfil = idPerfil;
        this.idUsuario = idUsuario;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.documento = documento;
        this.telefono = telefono;
        this.direccion = direccion;
        this.fechaActualizacion = fechaActualizacion;
    }

    // Getters y Setters
    public int getIdPerfil() {
        return idPerfil;
    }

    public void setIdPerfil(int idPerfil) {
        this.idPerfil = idPerfil;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getDocumento() {
        return documento;
    }

    public void setDocumento(String documento) {
        this.documento = documento;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getFotoUrl() {
        return fotoUrl;
    }

    public void setFotoUrl(String fotoUrl) {
        this.fotoUrl = fotoUrl;
    }

    public LocalDateTime getFechaActualizacion() {
        return fechaActualizacion;
    }

    public void setFechaActualizacion(LocalDateTime fechaActualizacion) {
        this.fechaActualizacion = fechaActualizacion;
    }

    @Override
    public String toString() {
        return "Perfil{id=" + idPerfil + ", idUsuario=" + idUsuario
                + ", documento='" + documento + "'}";
    }
}
