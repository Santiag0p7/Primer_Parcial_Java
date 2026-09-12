package com.inmobiliaria.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entidad POJO que representa una propiedad inmobiliaria.
 * Mapea la tabla 'propiedad' de la base de datos inmobiliaria.
 *
 * Incluye soporte de baja logica mediante el atributo 'estadoLogico'
 * (TRUE = activa, FALSE = eliminada logicamente).
 */
public class Propiedad implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idPropiedad;
    private String matriculaInmobiliaria;
    private String titulo;
    private String descripcion;
    private BigDecimal precio;
    private int habitaciones;
    private int banos;
    private BigDecimal areaM2;
    private String direccion;
    private boolean estadoLogico;
    private int idInmobiliaria;
    private int idTipo;
    private int idCiudad;
    private LocalDateTime fechaPublicacion;

    // Campos auxiliares para mostrar en las vistas (JOIN)
    private String nombreTipo;
    private String nombreCiudad;

    // Constructor vacio
    public Propiedad() {
    }

    // Constructor completo
    public Propiedad(int idPropiedad, String matriculaInmobiliaria, String titulo,
                     String descripcion, BigDecimal precio, int habitaciones,
                     int banos, BigDecimal areaM2, String direccion,
                     boolean estadoLogico, int idInmobiliaria, int idTipo,
                     int idCiudad, LocalDateTime fechaPublicacion) {
        this.idPropiedad = idPropiedad;
        this.matriculaInmobiliaria = matriculaInmobiliaria;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.precio = precio;
        this.habitaciones = habitaciones;
        this.banos = banos;
        this.areaM2 = areaM2;
        this.direccion = direccion;
        this.estadoLogico = estadoLogico;
        this.idInmobiliaria = idInmobiliaria;
        this.idTipo = idTipo;
        this.idCiudad = idCiudad;
        this.fechaPublicacion = fechaPublicacion;
    }

    // Getters y Setters
    public int getIdPropiedad() {
        return idPropiedad;
    }

    public void setIdPropiedad(int idPropiedad) {
        this.idPropiedad = idPropiedad;
    }

    public String getMatriculaInmobiliaria() {
        return matriculaInmobiliaria;
    }

    public void setMatriculaInmobiliaria(String matriculaInmobiliaria) {
        this.matriculaInmobiliaria = matriculaInmobiliaria;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public BigDecimal getPrecio() {
        return precio;
    }

    public void setPrecio(BigDecimal precio) {
        this.precio = precio;
    }

    public int getHabitaciones() {
        return habitaciones;
    }

    public void setHabitaciones(int habitaciones) {
        this.habitaciones = habitaciones;
    }

    public int getBanos() {
        return banos;
    }

    public void setBanos(int banos) {
        this.banos = banos;
    }

    public BigDecimal getAreaM2() {
        return areaM2;
    }

    public void setAreaM2(BigDecimal areaM2) {
        this.areaM2 = areaM2;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public boolean isEstadoLogico() {
        return estadoLogico;
    }

    public void setEstadoLogico(boolean estadoLogico) {
        this.estadoLogico = estadoLogico;
    }

    public int getIdInmobiliaria() {
        return idInmobiliaria;
    }

    public void setIdInmobiliaria(int idInmobiliaria) {
        this.idInmobiliaria = idInmobiliaria;
    }

    public int getIdTipo() {
        return idTipo;
    }

    public void setIdTipo(int idTipo) {
        this.idTipo = idTipo;
    }

    public int getIdCiudad() {
        return idCiudad;
    }

    public void setIdCiudad(int idCiudad) {
        this.idCiudad = idCiudad;
    }

    public LocalDateTime getFechaPublicacion() {
        return fechaPublicacion;
    }

    public void setFechaPublicacion(LocalDateTime fechaPublicacion) {
        this.fechaPublicacion = fechaPublicacion;
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

    @Override
    public String toString() {
        return "Propiedad{id=" + idPropiedad + ", matricula='" + matriculaInmobiliaria
                + "', titulo='" + titulo + "', estadoLogico=" + estadoLogico + "}";
    }
}
