<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="tituloPagina" value="${propiedad.titulo} - JSGE In-Mobiliaria" scope="request"/>

<%@ include file="/includes/header.jsp"%>

    <section class="section-padding" style="padding-top:120px; background:#F8F9FA;">
        <div class="container">

            <!-- Migas de pan -->
            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index">Inicio</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/buscar">Catalogo</a></li>
                    <li class="breadcrumb-item active" aria-current="page">${propiedad.titulo}</li>
                </ol>
            </nav>

            <div class="row g-4">
                <!-- Carrusel de imagenes -->
                <div class="col-lg-7">
                    <c:choose>
                        <c:when test="${empty imagenes}">
                            <div class="about-img-placeholder" style="border-radius:var(--radius-lg); min-height:400px;">
                                <i class="bi bi-image"></i>
                                <p>Sin imagenes disponibles</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div id="carruselPropiedad" class="carousel slide shadow-sm"
                                 data-bs-ride="carousel" style="border-radius:var(--radius-lg); overflow:hidden;">
                                <div class="carousel-indicators">
                                    <c:forEach var="img" items="${imagenes}" varStatus="st">
                                        <button type="button" data-bs-target="#carruselPropiedad"
                                                data-bs-slide-to="${st.index}"
                                                class="${st.first ? 'active' : ''}"
                                                aria-label="Imagen ${st.index + 1}"></button>
                                    </c:forEach>
                                </div>
                                <div class="carousel-inner">
                                    <c:forEach var="img" items="${imagenes}" varStatus="st">
                                        <div class="carousel-item ${st.first ? 'active' : ''}">
                                            <img src="${img.urlImagen}" class="d-block w-100"
                                                 alt="Imagen de ${propiedad.titulo}"
                                                 style="height:460px; object-fit:cover;"
                                                 onerror="this.src='https://via.placeholder.com/800x460?text=Imagen+no+disponible'">
                                        </div>
                                    </c:forEach>
                                </div>
                                <c:if test="${fn:length(imagenes) > 1}">
                                    <button class="carousel-control-prev" type="button"
                                            data-bs-target="#carruselPropiedad" data-bs-slide="prev">
                                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                        <span class="visually-hidden">Anterior</span>
                                    </button>
                                    <button class="carousel-control-next" type="button"
                                            data-bs-target="#carruselPropiedad" data-bs-slide="next">
                                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                        <span class="visually-hidden">Siguiente</span>
                                    </button>
                                </c:if>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Informacion principal -->
                <div class="col-lg-5">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body p-4">
                            <span class="badge badge-venta mb-2">${propiedad.nombreTipo}</span>
                            <h2 style="color:#0B2545;">${propiedad.titulo}</h2>
                            <p class="text-muted mb-2">
                                <i class="bi bi-geo-alt-fill text-gold me-1"></i>
                                ${propiedad.direccion}${not empty propiedad.direccion ? ', ' : ''}${propiedad.nombreCiudad}
                            </p>
                            <p class="text-muted small mb-3">
                                <i class="bi bi-card-text me-1"></i> Matricula: ${propiedad.matriculaInmobiliaria}
                            </p>

                            <div class="property-price mb-3" style="font-size:2rem;">
                                <fmt:formatNumber value="${propiedad.precio}" type="currency"
                                                  currencySymbol="$" maxFractionDigits="0"/>
                            </div>

                            <div class="row text-center g-2 mb-4">
                                <div class="col-4">
                                    <div class="border rounded p-2">
                                        <i class="bi bi-door-open fs-4 text-gold"></i>
                                        <div class="fw-bold">${propiedad.habitaciones}</div>
                                        <small class="text-muted">Habitaciones</small>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="border rounded p-2">
                                        <i class="bi bi-droplet fs-4 text-gold"></i>
                                        <div class="fw-bold">${propiedad.banos}</div>
                                        <small class="text-muted">Banos</small>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="border rounded p-2">
                                        <i class="bi bi-aspect-ratio fs-4 text-gold"></i>
                                        <div class="fw-bold">${propiedad.areaM2}</div>
                                        <small class="text-muted">m&sup2;</small>
                                    </div>
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${sessionScope.rol == 'CLIENTE'}">
                                    <button type="button" class="btn btn-gold w-100"
                                            data-bs-toggle="modal" data-bs-target="#modalAgendar">
                                        <i class="bi bi-calendar-plus me-2"></i> Agendar visita
                                    </button>
                                </c:when>
                                <c:when test="${not empty sessionScope.idUsuario}">
                                    <button type="button" class="btn btn-secondary w-100" disabled>
                                        <i class="bi bi-info-circle me-2"></i> Solo los clientes pueden agendar visitas
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/LoginServlet"
                                       class="btn btn-gold w-100">
                                        <i class="bi bi-box-arrow-in-right me-2"></i> Inicie sesion para agendar cita
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Descripcion -->
            <div class="card border-0 shadow-sm mt-4">
                <div class="card-body p-4">
                    <h4 style="color:#0B2545;"><i class="bi bi-file-text me-2 text-gold"></i>Descripcion</h4>
                    <p class="section-text mb-0">
                        <c:choose>
                            <c:when test="${not empty propiedad.descripcion}">${propiedad.descripcion}</c:when>
                            <c:otherwise><span class="text-muted">Sin descripcion registrada.</span></c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>

            <!-- Caracteristicas (N:M) -->
            <div class="card border-0 shadow-sm mt-4">
                <div class="card-body p-4">
                    <h4 style="color:#0B2545;"><i class="bi bi-check2-square me-2 text-gold"></i>Caracteristicas</h4>
                    <c:choose>
                        <c:when test="${empty caracteristicas}">
                            <p class="text-muted mb-0">Esta propiedad no tiene caracteristicas registradas.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="d-flex flex-wrap gap-2">
                                <c:forEach var="car" items="${caracteristicas}">
                                    <span class="badge rounded-pill text-bg-light border px-3 py-2">
                                        <i class="bi bi-check-circle-fill text-gold me-1"></i>${car.nombre}
                                    </span>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/buscar" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-1"></i> Volver al catalogo
                </a>
            </div>
        </div>
    </section>

    <!-- Modal de agendamiento de visita (solo CLIENTE) -->
    <c:if test="${sessionScope.rol == 'CLIENTE'}">
        <div class="modal fade" id="modalAgendar" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <form action="${pageContext.request.contextPath}/SolicitudServlet" method="post"
                      class="modal-content">
                    <input type="hidden" name="idPropiedad" value="${propiedad.idPropiedad}">

                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="bi bi-calendar-plus text-gold me-2"></i>Agendar visita
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>

                    <div class="modal-body">
                        <p class="mb-3">
                            Propiedad: <strong>${propiedad.titulo}</strong>
                        </p>

                        <div class="row g-3">
                            <div class="col-sm-6">
                                <label for="fechaVisita" class="form-label fw-semibold">
                                    Fecha <span class="text-danger">*</span>
                                </label>
                                <input type="date" class="form-control" id="fechaVisita"
                                       name="fechaVisita" required min="${fechaMinima}">
                            </div>
                            <div class="col-sm-6">
                                <label for="horaVisita" class="form-label fw-semibold">
                                    Hora <span class="text-danger">*</span>
                                </label>
                                <input type="time" class="form-control" id="horaVisita"
                                       name="horaVisita" required>
                            </div>
                            <div class="col-12">
                                <label for="comentario" class="form-label fw-semibold">Comentario</label>
                                <textarea class="form-control" id="comentario" name="comentario"
                                          rows="3" maxlength="500"
                                          placeholder="Cuentanos si prefieres algun horario especial..."></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-gold">
                            <i class="bi bi-send me-1"></i> Enviar solicitud
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </c:if>

<%@ include file="/includes/footer.jsp"%>
