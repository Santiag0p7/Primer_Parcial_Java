<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${empty sessionScope.idUsuario}">
    <c:redirect url="${pageContext.request.contextPath}/LoginServlet"/>
</c:if>
<c:set var="tituloPagina" value="Panel Administrador - Inmobiliaria UTS" scope="request"/>
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

                <div class="row g-4 mt-4">
                    <div class="col-md-3 col-sm-6">
                        <a href="#" class="text-decoration-none">
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
                        <a href="#" class="text-decoration-none">
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
