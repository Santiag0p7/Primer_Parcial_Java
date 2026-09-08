package com.inmobiliaria.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Entidad POJO que representa un usuario del sistema.
 * Mapea la tabla 'usuario' de la base de datos inmobiliaria.
 */
public class Usuario implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idUsuario;
    private String correo;
    private String passwordHash;
    private boolean estado;
    private LocalDateTime fechaRegistro;

    // Constructor vacio
    public Usuario() {
    }

    // Constructor completo
    public Usuario(int idUsuario, String correo, String passwordHash,
                   boolean estado, LocalDateTime fechaRegistro) {
        this.idUsuario = idUsuario;
        this.correo = correo;
        this.passwordHash = passwordHash;
        this.estado = estado;
        this.fechaRegistro = fechaRegistro;
    }

    // Getters y Setters
    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
    }

    public LocalDateTime getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(LocalDateTime fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    @Override
    public String toString() {
        return "Usuario{id=" + idUsuario + ", correo='" + correo + "', estado=" + estado + "}";
    }
}
