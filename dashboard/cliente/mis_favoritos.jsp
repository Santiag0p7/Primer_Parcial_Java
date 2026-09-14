<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:if test="${empty sessionScope.idUsuario}">
    <c:redirect url="${pageContext.request.contextPath}/LoginServlet"/>
</c:if>
<c:if test="${sessionScope.rol != 'CLIENTE'}">
    <c:redirect url="${pageContext.request.contextPath}/acceso_denegado.jsp"/>
</c:if>
<c:if test="${empty tituloPagina}">
    <c:set var="tituloPagina" value="Mis Favoritos - JSGE In-Mobiliaria" scope="request"/>
</c:if>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%@ include file="/includes/header.jsp"%>

<style>
    .fav-card { border: none; border-radius: var(--radius-md); box-shadow: var(--shadow-sm); transition: var(--transition); }
    .fav-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-md); }
</style>

<div class="container" style="padding-top:120px; padding-bottom:3rem;">

    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h2 class="mb-1" style="color:#0B2545;">
                <i class="bi bi-heart-fill me-2" style="color:var(--gold);"></i>Mis Favoritos
            </h2>
            <p class="text-muted mb-0">Propiedades que has guardado para revisar mas tarde.</p>
        </div>
        <a href="${ctx}/DashboardServlet" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left me-1"></i> Volver al panel
        </a>
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
    <c:if test="${not empty error}">
        <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty favoritos}">
            <div class="card fav-card">
                <div class="card-body text-center py-5">
                    <i class="bi bi-heart fs-1 text-muted d-block mb-3"></i>
                    <h5 class="text-muted">Aun no tienes propiedades favoritas.</h5>
                    <p class="text-muted">Explora el catalogo y guarda las que mas te gusten.</p>
                    <a href="${ctx}/buscar" class="btn btn-gold mt-2">
                        <i class="bi bi-collection me-1"></i> Ir al catalogo
                    </a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-4">
                <c:forEach var="p" items="${favoritos}">
                    <div class="col-md-4 col-sm-6">
                        <div class="card fav-card h-100">
                            <div class="card-body d-flex flex-column">
                                <span class="badge text-bg-light border align-self-start mb-2">${p.nombreTipo}</span>
                                <h5 class="text-dark mb-2">${p.titulo}</h5>
                                <p class="text-muted small mb-2">
                                    <i class="bi bi-geo-alt-fill text-gold me-1"></i>${p.nombreCiudad}
                                </p>
                                <div class="property-price mb-3" style="font-size:1.35rem;">
                                    <fmt:formatNumber value="${p.precio}" type="currency"
                                                      currencySymbol="$" maxFractionDigits="0"/>
                                </div>

                                <div class="mt-auto d-flex gap-2">
                                    <a href="${ctx}/propiedad?id=${p.idPropiedad}"
                                       class="btn btn-gold btn-sm flex-fill">
                                        <i class="bi bi-eye me-1"></i> Ver
                                    </a>
                                    <form action="${ctx}/FavoritoServlet" method="post" class="flex-fill">
                                        <input type="hidden" name="action" value="eliminar">
                                        <input type="hidden" name="idPropiedad" value="${p.idPropiedad}">
                                        <input type="hidden" name="origen" value="lista">
                                        <button type="submit" class="btn btn-outline-danger btn-sm w-100"
                                                onclick="return confirm('¿Quitar ${p.titulo} de tus favoritos?');">
                                            <i class="bi bi-trash3 me-1"></i> Quitar
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
