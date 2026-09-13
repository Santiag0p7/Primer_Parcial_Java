package com.inmobiliaria.model;

import java.io.Serializable;

/**
 * Entidad POJO que representa una imagen de la galeria de una propiedad.
 * Mapea la tabla 'imagen_propiedad' (relacion 1:N con propiedad).
 */
public class ImagenPropiedad implements Serializable {

    private static final long serialVersionUID = 1L;

    private int idImagen;
    private int idPropiedad;
    private String urlImagen;
    private boolean esPrincipal;

    // Constructor vacio
    public ImagenPropiedad() {
    }

    // Constructor completo
    public ImagenPropiedad(int idImagen, int idPropiedad, String urlImagen, boolean esPrincipal) {
        this.idImagen = idImagen;
        this.idPropiedad = idPropiedad;
        this.urlImagen = urlImagen;
        this.esPrincipal = esPrincipal;
    }

    // Getters y Setters
    public int getIdImagen() {
        return idImagen;
    }

    public void setIdImagen(int idImagen) {
        this.idImagen = idImagen;
    }

    public int getIdPropiedad() {
        return idPropiedad;
    }

    public void setIdPropiedad(int idPropiedad) {
        this.idPropiedad = idPropiedad;
    }

    public String getUrlImagen() {
        return urlImagen;
    }

    public void setUrlImagen(String urlImagen) {
        this.urlImagen = urlImagen;
    }

    public boolean isEsPrincipal() {
        return esPrincipal;
    }

    public void setEsPrincipal(boolean esPrincipal) {
        this.esPrincipal = esPrincipal;
    }

    @Override
    public String toString() {
        return "ImagenPropiedad{id=" + idImagen + ", idPropiedad=" + idPropiedad
                + ", url='" + urlImagen + "', principal=" + esPrincipal + "}";
    }
}
