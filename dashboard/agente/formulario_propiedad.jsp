<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:if test="${empty sessionScope.idUsuario}">
    <c:redirect url="${pageContext.request.contextPath}/LoginServlet"/>
</c:if>
<c:set var="esEdicion" value="${not empty propiedad and propiedad.idPropiedad > 0}"/>
<c:set var="tituloPagina" value="${esEdicion ? 'Editar' : 'Nueva'} Propiedad - Inmobiliaria UTS" scope="request"/>
<%@ include file="/includes/header.jsp"%>

<style>
    .form-card { border: none; border-radius: var(--radius-md); box-shadow: var(--shadow-sm); }
    .form-label { font-weight: 600; color: #0B2545; font-size: 0.9rem; }
    .form-control:focus, .form-select:focus { border-color: var(--gold); box-shadow: 0 0 0 3px rgba(184,134,11,0.15); }
    .section-title-form { font-size: 1rem; font-weight: 700; color: var(--gold-dark);
                          text-transform: uppercase; letter-spacing: 0.5px; }
</style>

    <div class="container" style="padding-top:120px; padding-bottom:2rem;">
        <div class="d-flex align-items-center justify-content-between mb-4">
            <h2 class="mb-0" style="color:#0B2545;">
                <i class="bi bi-${esEdicion ? 'pencil-square' : 'plus-circle'} me-2" style="color:var(--gold);"></i>
                ${esEdicion ? 'Editar Propiedad' : 'Nueva Propiedad'}
            </h2>
            <a href="${pageContext.request.contextPath}/PropiedadServlet?action=list"
               class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left me-1"></i> Volver
            </a>
        </div>

        <!-- Alerta de error (incluye matricula duplicada) -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
            </div>
        </c:if>

        <div class="card form-card">
            <div class="card-body p-4">
                <form action="${pageContext.request.contextPath}/PropiedadServlet" method="post" novalidate>
                    <input type="hidden" name="action" value="${esEdicion ? 'update' : 'insert'}">
                    <c:if test="${esEdicion}">
                        <input type="hidden" name="idPropiedad" value="${propiedad.idPropiedad}">
                    </c:if>

                    <!-- Identificacion -->
                    <p class="section-title-form mb-3"><i class="bi bi-card-text me-1"></i> Identificacion</p>
                    <div class="row g-3 mb-4">
                        <div class="col-md-4">
                            <label for="matriculaInmobiliaria" class="form-label">Matricula Inmobiliaria *</label>
                            <input type="text" class="form-control" id="matriculaInmobiliaria"
                                   name="matriculaInmobiliaria" maxlength="50" required
                                   placeholder="Ej: MAT-001-2026"
                                   value="${propiedad.matriculaInmobiliaria}">
                            <div class="form-text">Debe ser unica en el sistema.</div>
                        </div>
                        <div class="col-md-8">
                            <label for="titulo" class="form-label">Titulo *</label>
                            <input type="text" class="form-control" id="titulo" name="titulo"
                                   maxlength="150" required placeholder="Ej: Casa campestre en venta"
                                   value="${propiedad.titulo}">
                        </div>
                        <div class="col-12">
                            <label for="descripcion" class="form-label">Descripcion</label>
                            <textarea class="form-control" id="descripcion" name="descripcion"
                                      rows="3" maxlength="1000"
                                      placeholder="Descripcion detallada del inmueble...">${propiedad.descripcion}</textarea>
                        </div>
                    </div>

                    <!-- Detalles -->
                    <p class="section-title-form mb-3"><i class="bi bi-geo-alt me-1"></i> Detalles</p>
                    <div class="row g-3 mb-4">
                        <div class="col-md-4">
                            <label for="idTipo" class="form-label">Tipo de Propiedad *</label>
                            <select class="form-select" id="idTipo" name="idTipo" required>
                                <option value="">-- Seleccione --</option>
                                <c:forEach var="t" items="${tipos}">
                                    <option value="${t.key}" ${propiedad.idTipo == t.key ? 'selected' : ''}>
                                        ${t.value}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="idCiudad" class="form-label">Ciudad *</label>
                            <select class="form-select" id="idCiudad" name="idCiudad" required>
                                <option value="">-- Seleccione --</option>
                                <c:forEach var="c" items="${ciudades}">
                                    <option value="${c.key}" ${propiedad.idCiudad == c.key ? 'selected' : ''}>
                                        ${c.value}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="direccion" class="form-label">Direccion</label>
                            <input type="text" class="form-control" id="direccion" name="direccion"
                                   maxlength="180" placeholder="Ej: Calle 10 # 20-30"
                                   value="${propiedad.direccion}">
                        </div>
                    </div>

                    <!-- Caracteristicas -->
                    <p class="section-title-form mb-3"><i class="bi bi-rulers me-1"></i> Caracteristicas</p>
                    <div class="row g-3 mb-4">
                        <div class="col-md-3">
                            <label for="precio" class="form-label">Precio (COP) *</label>
                            <input type="number" class="form-control" id="precio" name="precio"
                                   required min="0" step="0.01" placeholder="250000000"
                                   value="${propiedad.precio}">
                        </div>
                        <div class="col-md-3">
                            <label for="habitaciones" class="form-label">Habitaciones *</label>
                            <input type="number" class="form-control" id="habitaciones" name="habitaciones"
                                   required min="0" max="50" step="1" value="${propiedad.habitaciones}">
                        </div>
                        <div class="col-md-3">
                            <label for="banos" class="form-label">Banos *</label>
                            <input type="number" class="form-control" id="banos" name="banos"
                                   required min="0" max="50" step="1" value="${propiedad.banos}">
                        </div>
                        <div class="col-md-3">
                            <label for="areaM2" class="form-label">Area (m2) *</label>
                            <input type="number" class="form-control" id="areaM2" name="areaM2"
                                   required min="0" step="0.01" placeholder="120.5"
                                   value="${propiedad.areaM2}">
                        </div>
                    </div>

                    <!-- Caracteristicas N:M -->
                    <p class="section-title-form mb-3"><i class="bi bi-check2-square me-1"></i> Caracteristicas del Inmueble</p>
                    <div class="row g-2 mb-4">
                        <c:choose>
                            <c:when test="${empty caracteristicas}">
                                <div class="col-12">
                                    <p class="text-muted small mb-0">
                                        No hay caracteristicas en el catalogo. Ejecute el script sprint2.sql.
                                    </p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="car" items="${caracteristicas}">
                                    <div class="col-md-3 col-sm-6">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox"
                                                   name="caracteristicas" value="${car.idCaracteristica}"
                                                   id="car_${car.idCaracteristica}"
                                                   ${idsSeleccionados.contains(car.idCaracteristica) ? 'checked' : ''}>
                                            <label class="form-check-label" for="car_${car.idCaracteristica}">
                                                ${car.nombre}
                                            </label>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Galeria de imagenes 1:N -->
                    <p class="section-title-form mb-3"><i class="bi bi-images me-1"></i> Galeria de Imagenes</p>
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label for="urlPrincipal" class="form-label">URL Imagen Principal</label>
                            <input type="url" class="form-control" id="urlPrincipal" name="urlPrincipal"
                                   maxlength="500" placeholder="https://..."
                                   value="${not empty imagenes ? imagenes[0].urlImagen : ''}">
                            <div class="form-text">Imagen destacada del inmueble.</div>
                        </div>
                        <div class="col-md-6">
                            <label for="urlsImagenes" class="form-label">URLs Imagenes Adicionales</label>
                            <textarea class="form-control" id="urlsImagenes" name="urlsImagenes"
                                      rows="3" placeholder="Una URL por linea"></textarea>
                            <div class="form-text">Una URL por linea (imagenes secundarias).</div>
                        </div>
                        <c:if test="${esEdicion}">
                            <div class="col-12">
                                <a href="${pageContext.request.contextPath}/PropiedadServlet?action=galeria&id=${propiedad.idPropiedad}"
                                   class="btn btn-outline-primary btn-sm">
                                    <i class="bi bi-images me-1"></i> Gestionar galeria (${fn:length(imagenes)} imagenes)
                                </a>
                            </div>
                        </c:if>
                    </div>

                    <div class="d-flex gap-2 pt-2 border-top">
                        <button type="submit" class="btn btn-gold">
                            <i class="bi bi-save me-1"></i> ${esEdicion ? 'Actualizar' : 'Guardar'} Propiedad
                        </button>
                        <a href="${pageContext.request.contextPath}/PropiedadServlet?action=list"
                           class="btn btn-outline-secondary">Cancelar</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
