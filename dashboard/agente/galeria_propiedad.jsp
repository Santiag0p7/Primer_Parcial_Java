<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:if test="${empty sessionScope.idUsuario}">
    <c:redirect url="${pageContext.request.contextPath}/LoginServlet"/>
</c:if>
<c:set var="tituloPagina" value="Galeria de Propiedad - JSGE In-Mobiliaria" scope="request"/>
<%@ include file="/includes/header.jsp"%>

<style>
    .gallery-card { border: none; border-radius: var(--radius-md); box-shadow: var(--shadow-sm); overflow: hidden; }
    .gallery-thumb { width: 100%; height: 180px; object-fit: cover; background: #e9ecef; }
    .badge-principal { background: var(--gold); color: #fff; font-weight: 600; }
    .form-label { font-weight: 600; color: #0B2545; font-size: 0.9rem; }
    .form-control:focus { border-color: var(--gold); box-shadow: 0 0 0 3px rgba(184,134,11,0.15); }
</style>

    <div class="container" style="padding-top:120px; padding-bottom:2rem;">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
            <div>
                <h2 class="mb-1" style="color:#0B2545;">
                    <i class="bi bi-images me-2" style="color:var(--gold);"></i>Galeria de Imagenes
                </h2>
                <p class="text-muted mb-0">
                    ${propiedad.titulo}
                    <span class="badge badge-tipo ms-1">${propiedad.nombreTipo}</span>
                    <span class="text-secondary ms-1">${propiedad.nombreCiudad}</span>
                </p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/PropiedadServlet?action=edit&id=${propiedad.idPropiedad}"
                   class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i> Volver a edicion
                </a>
                <a href="${pageContext.request.contextPath}/PropiedadServlet?action=list"
                   class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-list-ul me-1"></i> Mis Propiedades
                </a>
            </div>
        </div>

        <!-- Alertas -->
        <c:if test="${not empty sessionScope.mensajeExito}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.mensajeExito}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
            </div>
            <c:remove var="mensajeExito" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.mensajeError}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.mensajeError}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
            </div>
            <c:remove var="mensajeError" scope="session"/>
        </c:if>

        <!-- Formulario para agregar imagen -->
        <div class="card gallery-card mb-4">
            <div class="card-body p-4">
                <h5 class="mb-3" style="color:#0B2545;">
                    <i class="bi bi-plus-circle me-1" style="color:var(--gold);"></i>Agregar nueva imagen
                </h5>
                <form action="${pageContext.request.contextPath}/PropiedadServlet" method="post" class="row g-3 align-items-end">
                    <input type="hidden" name="action" value="addImage">
                    <input type="hidden" name="idPropiedad" value="${propiedad.idPropiedad}">

                    <div class="col-md-7">
                        <label for="urlImagen" class="form-label">URL de la imagen *</label>
                        <input type="url" class="form-control" id="urlImagen" name="urlImagen"
                               maxlength="500" required placeholder="https://ejemplo.com/foto.jpg">
                    </div>
                    <div class="col-md-3">
                        <div class="form-check mt-4 pt-2">
                            <input class="form-check-input" type="checkbox"
                                   id="esPrincipal" name="esPrincipal" value="true">
                            <label class="form-check-label" for="esPrincipal">
                                Marcar como principal
                            </label>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-gold w-100">
                            <i class="bi bi-plus-lg me-1"></i> Agregar
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Grilla de imagenes -->
        <c:choose>
            <c:when test="${empty imagenes}">
                <div class="card gallery-card">
                    <div class="card-body text-center py-5 text-muted">
                        <i class="bi bi-image fs-1 d-block mb-2"></i>
                        Esta propiedad aun no tiene imagenes en su galeria.
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <p class="text-muted small mb-2">
                    <i class="bi bi-collection me-1"></i>${fn:length(imagenes)} imagen(es) registradas
                </p>
                <div class="row g-3">
                    <c:forEach var="img" items="${imagenes}">
                        <div class="col-md-4 col-sm-6">
                            <div class="card gallery-card h-100">
                                <img src="${img.urlImagen}" class="gallery-thumb" alt="Imagen de la propiedad"
                                     onerror="this.src='https://via.placeholder.com/400x180?text=Imagen+no+disponible'">
                                <div class="card-body">
                                    <c:if test="${img.esPrincipal}">
                                        <span class="badge badge-principal mb-2">
                                            <i class="bi bi-star-fill me-1"></i>Principal
                                        </span>
                                    </c:if>
                                    <p class="small text-muted mb-3" style="word-break:break-all;">
                                        ${img.urlImagen}
                                    </p>
                                    <button type="button" class="btn btn-sm btn-outline-danger"
                                            data-bs-toggle="modal" data-bs-target="#modalEliminar"
                                            data-id="${img.idImagen}"
                                            data-url="${img.urlImagen}">
                                        <i class="bi bi-trash3 me-1"></i> Eliminar
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Modal de confirmacion de eliminacion -->
    <div class="modal fade" id="modalEliminar" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-exclamation-triangle-fill text-danger me-2"></i>Eliminar imagen
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    Esta seguro de eliminar la imagen <strong id="urlEliminar"></strong> de la galeria?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="#" id="btnConfirmarEliminar" class="btn btn-danger">
                        <i class="bi bi-trash3 me-1"></i> Eliminar
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var modalEliminar = document.getElementById('modalEliminar');
        modalEliminar.addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var idImagen = button.getAttribute('data-id');
            var url = button.getAttribute('data-url');
            document.getElementById('urlEliminar').textContent = url;
            document.getElementById('btnConfirmarEliminar').href =
                '${pageContext.request.contextPath}/PropiedadServlet?action=deleteImage'
                + '&idImagen=' + idImagen + '&idPropiedad=${propiedad.idPropiedad}';
        });
    </script>
</body>
</html>
