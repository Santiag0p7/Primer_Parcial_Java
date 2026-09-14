<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:if test="${empty sessionScope.idUsuario}">
    <c:redirect url="${pageContext.request.contextPath}/LoginServlet"/>
</c:if>
<c:if test="${sessionScope.rol != 'ADMINISTRADOR'}">
    <c:redirect url="${pageContext.request.contextPath}/acceso_denegado.jsp"/>
</c:if>
<c:if test="${empty tituloPagina}">
    <c:set var="tituloPagina" value="Panel Administrador - JSGE In-Mobiliaria" scope="request"/>
</c:if>
<c:set var="statProp" value="${not empty totalPropiedadesActivas ? totalPropiedadesActivas : 0}"/>
<c:set var="statSol" value="${not empty totalSolicitudesPendientes ? totalSolicitudesPendientes : 0}"/>
<c:set var="statUsu" value="${not empty totalUsuarios ? totalUsuarios : 0}"/>
<c:set var="statCiu" value="${not empty metricasPorCiudad ? fn:length(metricasPorCiudad) : 0}"/>
<%@ include file="/includes/header.jsp"%>

<style>
    .panel-card { border: none; border-radius: var(--radius-md); box-shadow: var(--shadow-sm); transition: var(--transition); }
    .panel-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-md); }
</style>

<div style="padding-top:120px; padding-bottom:3rem; background:#F8F9FA; min-height:100vh;">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10 text-center">
                <div class="mb-4">
                    <i class="bi bi-shield-lock-fill" style="font-size:4rem; color:var(--gold);"></i>
                </div>
                <h1 style="font-family:'Playfair Display',serif; color:#0B2545;">Panel de Administrador</h1>
                <p class="text-muted fs-5 mt-3">
                    Bienvenido, <strong>${sessionScope.correo}</strong>.<br>
                    Desde aqui puedes gestionar usuarios, propiedades, roles y configuraciones del sistema.
                </p>

                <!-- ================= METRICAS (Sprint 3 - Item 3) ================= -->
                <c:if test="${not empty errorMetricas}">
                    <div class="alert alert-danger mt-3">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMetricas}
                    </div>
                </c:if>

                <div class="row g-4 mt-4">
                    <div class="col-md-3 col-sm-6">
                        <div class="card panel-card h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center justify-content-between text-start">
                                    <div>
                                        <p class="text-muted text-uppercase small mb-1">Propiedades activas</p>
                                        <h2 class="fw-bold mb-0" style="color:#0B2545;">${statProp}</h2>
                                    </div>
                                    <i class="bi bi-house-door-fill fs-1" style="color:var(--gold);"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="card panel-card h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center justify-content-between text-start">
                                    <div>
                                        <p class="text-muted text-uppercase small mb-1">Solicitudes pendientes</p>
                                        <h2 class="fw-bold mb-0" style="color:#0B2545;">${statSol}</h2>
                                    </div>
                                    <i class="bi bi-calendar2-week-fill fs-1" style="color:var(--gold);"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="card panel-card h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center justify-content-between text-start">
                                    <div>
                                        <p class="text-muted text-uppercase small mb-1">Usuarios</p>
                                        <h2 class="fw-bold mb-0" style="color:#0B2545;">${statUsu}</h2>
                                    </div>
                                    <i class="bi bi-people-fill fs-1" style="color:var(--gold);"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="card panel-card h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center justify-content-between text-start">
                                    <div>
                                        <p class="text-muted text-uppercase small mb-1">Ciudades</p>
                                        <h2 class="fw-bold mb-0" style="color:#0B2545;">${statCiu}</h2>
                                    </div>
                                    <i class="bi bi-geo-alt-fill fs-1" style="color:var(--gold);"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <h5 class="mt-5 mb-0" style="color:#0B2545;">Accesos rapidos</h5>

                <div class="row g-4 mt-4">
                    <div class="col-md-3 col-sm-6">
                        <a href="${pageContext.request.contextPath}/AdminUsuarioServlet" class="text-decoration-none">
                            <div class="card panel-card h-100">
                                <div class="card-body text-center">
                                    <i class="bi bi-people-fill fs-1" style="color:var(--gold);"></i>
                                    <h5 class="mt-2 text-dark">Usuarios</h5>
                                    <p class="text-muted small mb-0">Gestionar cuentas y roles</p>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <a href="#" class="text-decoration-none">
                            <div class="card panel-card h-100">
                                <div class="card-body text-center">
                                    <i class="bi bi-house-door-fill fs-1" style="color:var(--gold);"></i>
                                    <h5 class="mt-2 text-dark">Propiedades</h5>
                                    <p class="text-muted small mb-0">Administrar inmuebles</p>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <a href="${pageContext.request.contextPath}/ReporteServlet" class="text-decoration-none">
                            <div class="card panel-card h-100">
                                <div class="card-body text-center">
                                    <i class="bi bi-bar-chart-fill fs-1" style="color:var(--gold);"></i>
                                    <h5 class="mt-2 text-dark">Reportes</h5>
                                    <p class="text-muted small mb-0">Estadisticas del sistema</p>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <a href="${pageContext.request.contextPath}/AdminParametrosServlet" class="text-decoration-none">
                            <div class="card panel-card h-100">
                                <div class="card-body text-center">
                                    <i class="bi bi-sliders fs-1" style="color:var(--gold);"></i>
                                    <h5 class="mt-2 text-dark">Parametros</h5>
                                    <p class="text-muted small mb-0">Ciudades, tipos y caracteristicas</p>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <a href="${pageContext.request.contextPath}/PerfilServlet" class="text-decoration-none">
                            <div class="card panel-card h-100">
                                <div class="card-body text-center">
                                    <i class="bi bi-person-badge-fill fs-1" style="color:var(--gold);"></i>
                                    <h5 class="mt-2 text-dark">Mi Perfil</h5>
                                    <p class="text-muted small mb-0">Datos personales</p>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>

                <!-- ================= AGRUPACIONES ================= -->
                <div class="row g-4 mt-5 text-start">
                    <div class="col-md-6">
                        <div class="card panel-card h-100">
                            <div class="card-header bg-white fw-semibold" style="color:#0B2545;">
                                <i class="bi bi-geo-alt me-1" style="color:var(--gold);"></i> Propiedades por ciudad
                            </div>
                            <ul class="list-group list-group-flush">
                                <c:choose>
                                    <c:when test="${empty metricasPorCiudad}">
                                        <li class="list-group-item text-muted">Sin datos disponibles.</li>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="m" items="${metricasPorCiudad}">
                                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                                <span>${m.etiqueta}</span>
                                                <span class="badge text-bg-primary rounded-pill">${m.total}</span>
                                            </li>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card panel-card h-100">
                            <div class="card-header bg-white fw-semibold" style="color:#0B2545;">
                                <i class="bi bi-house-door me-1" style="color:var(--gold);"></i> Propiedades por tipo
                            </div>
                            <ul class="list-group list-group-flush">
                                <c:choose>
                                    <c:when test="${empty metricasPorTipo}">
                                        <li class="list-group-item text-muted">Sin datos disponibles.</li>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="m" items="${metricasPorTipo}">
                                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                                <span>${m.etiqueta}</span>
                                                <span class="badge text-bg-secondary rounded-pill">${m.total}</span>
                                            </li>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
