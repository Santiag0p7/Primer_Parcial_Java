<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${empty sessionScope.idUsuario}">
    <c:redirect url="${pageContext.request.contextPath}/LoginServlet"/>
</c:if>
<c:set var="tituloPagina" value="Mi Panel - JSGE In-Mobiliaria" scope="request"/>
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
                    <i class="bi bi-person-circle" style="font-size:4rem; color:var(--gold);"></i>
                </div>
                <h1 style="font-family:'Playfair Display',serif; color:#0B2545;">Mi Panel</h1>
                <p class="text-muted fs-5 mt-3">
                    Bienvenido, <strong>${sessionScope.correo}</strong>.<br>
                    Explora propiedades, agenda visitas y gestiona tus consultas inmobiliarias.
                </p>

                <div class="row g-4 mt-4">
                    <div class="col-md-3 col-sm-6">
                        <a href="${pageContext.request.contextPath}/buscar" class="text-decoration-none">
                            <div class="card panel-card h-100">
                                <div class="card-body text-center">
                                    <i class="bi bi-search fs-1" style="color:var(--gold);"></i>
                                    <h5 class="mt-2 text-dark">Buscar</h5>
                                    <p class="text-muted small mb-0">Explorar propiedades</p>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <a href="#" class="text-decoration-none">
                            <div class="card panel-card h-100">
                                <div class="card-body text-center">
                                    <i class="bi bi-heart-fill fs-1" style="color:var(--gold);"></i>
                                    <h5 class="mt-2 text-dark">Favoritos</h5>
                                    <p class="text-muted small mb-0">Propiedades guardadas</p>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <a href="${pageContext.request.contextPath}/SolicitudServlet" class="text-decoration-none">
                            <div class="card panel-card h-100">
                                <div class="card-body text-center">
                                    <i class="bi bi-calendar-event fs-1" style="color:var(--gold);"></i>
                                    <h5 class="mt-2 text-dark">Mis Citas</h5>
                                    <p class="text-muted small mb-0">Visitas programadas</p>
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
