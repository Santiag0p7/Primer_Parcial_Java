<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:if test="${empty sessionScope.idUsuario}">
    <c:redirect url="${pageContext.request.contextPath}/LoginServlet"/>
</c:if>
<c:if test="${sessionScope.rol != 'INMOBILIARIA'}">
    <c:redirect url="${pageContext.request.contextPath}/acceso_denegado.jsp"/>
</c:if>
<c:if test="${empty tituloPagina}">
    <c:set var="tituloPagina" value="Panel Agente - JSGE In-Mobiliaria" scope="request"/>
</c:if>
<c:set var="statProp" value="${not empty totalPropiedadesActivas ? totalPropiedadesActivas : 0}"/>
<c:set var="statSol" value="${not empty totalSolicitudesPendientes ? totalSolicitudesPendientes : 0}"/>
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
                    <i class="bi bi-person-badge-fill" style="font-size:4rem; color:var(--gold);"></i>
                </div>
                <h1 style="font-family:'Playfair Display',serif; color:#0B2545;">Panel de Agente Inmobiliario</h1>
                <p class="text-muted fs-5 mt-3">
                    Bienvenido, <strong>${sessionScope.correo}</strong>.<br>
                    Gestiona las propiedades asignadas, atiende consultas de clientes y agenda visitas.
                </p>

                <!-- ================= METRICAS (Sprint 3 - Item 3) ================= -->
                <c:if test="${not empty errorMetricas}">
                    <div class="alert alert-danger mt-3">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMetricas}
                    </div>
                </c:if>

                <div class="row g-4 mt-4">
                    <div class="col-md-6">
                        <div class="card panel-card h-100">
                            <div class="card-body">
                                <div class="d-flex align-items-center justify-content-between text-start">
                                    <div>
                                        <p class="text-muted text-uppercase small mb-1">Mis propiedades activas</p>
                                        <h2 class="fw-bold mb-0" style="color:#0B2545;">${statProp}</h2>
                                    </div>
                                    <i class="bi bi-house-door-fill fs-1" style="color:var(--gold);"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
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
                </div>

                <h5 class="mt-5 mb-0" style="color:#0B2545;">Accesos rapidos</h5>

                <div class="row g-4 mt-4">
                    <div class="col-md-3 col-sm-6">
                        <a href="${pageContext.request.contextPath}/PropiedadServlet?action=list" class="text-decoration-none">
                            <div class="card panel-card h-100">
                                <div class="card-body text-center">
                                    <i class="bi bi-house-door-fill fs-1" style="color:var(--gold);"></i>
                                    <h5 class="mt-2 text-dark">Mis Propiedades</h5>
                                    <p class="text-muted small mb-0">Propiedades asignadas</p>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <a href="${pageContext.request.contextPath}/PropiedadServlet?action=new" class="text-decoration-none">
                            <div class="card panel-card h-100">
                                <div class="card-body text-center">
                                    <i class="bi bi-plus-circle-fill fs-1" style="color:var(--gold);"></i>
                                    <h5 class="mt-2 text-dark">Publicar</h5>
                                    <p class="text-muted small mb-0">Nueva propiedad</p>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <a href="${pageContext.request.contextPath}/SolicitudServlet" class="text-decoration-none">
                            <div class="card panel-card h-100">
                                <div class="card-body text-center">
                                    <i class="bi bi-calendar2-week-fill fs-1" style="color:var(--gold);"></i>
                                    <h5 class="mt-2 text-dark">Solicitudes</h5>
                                    <p class="text-muted small mb-0">Citas por gestionar</p>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <a href="${pageContext.request.contextPath}/SolicitudCompraServlet" class="text-decoration-none">
                            <div class="card panel-card h-100">
                                <div class="card-body text-center">
                                    <i class="bi bi-file-earmark-check-fill fs-1" style="color:var(--gold);"></i>
                                    <h5 class="mt-2 text-dark">Compra/Arriendo</h5>
                                    <p class="text-muted small mb-0">Aprobar solicitudes y documentos</p>
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
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
