<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Inmobiliaria UTS - Sistema de Administracion Inmobiliaria. Encuentra tu hogar ideal en Bucaramanga y la region.">
    <title>${tituloPagina != null ? tituloPagina : 'Inmobiliaria UTS'}</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css?v=3" rel="stylesheet">
</head>
<body>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="rol" value="${sessionScope.rol}"/>

<nav class="navbar navbar-expand-lg navbar-dark fixed-top" id="mainNav">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${ctx}/index">
            <i class="bi bi-buildings-fill brand-icon me-2"></i>
            <span class="brand-text">Inmobiliaria <span class="brand-accent">UTS</span></span>
        </a>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarNav" aria-controls="navbarNav"
                aria-expanded="false" aria-label="Navegacion">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">

            <%-- ================= VISITANTE (sin sesion) ================= --%>
            <c:if test="${empty sessionScope.idUsuario}">
                <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/index">
                            <i class="bi bi-house-door me-1"></i> Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/buscar">
                            <i class="bi bi-collection me-1"></i> Catalogo
                        </a>
                    </li>
                </ul>
                <div class="d-flex gap-2">
                    <a href="${ctx}/LoginServlet" class="btn btn-outline-light btn-nav">
                        <i class="bi bi-box-arrow-in-right me-1"></i> Iniciar Sesion
                    </a>
                    <a href="${ctx}/RegistroServlet" class="btn btn-gold btn-nav">
                        <i class="bi bi-person-plus me-1"></i> Registrarse
                    </a>
                </div>
            </c:if>

            <%-- ================= CLIENTE ================= --%>
            <c:if test="${rol == 'CLIENTE'}">
                <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/index">
                            <i class="bi bi-house-door me-1"></i> Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/buscar">
                            <i class="bi bi-collection me-1"></i> Catalogo
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/dashboard/cliente/index.jsp#solicitudes">
                            <i class="bi bi-calendar-check me-1"></i> Mis Citas/Solicitudes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/PerfilServlet">
                            <i class="bi bi-person-circle me-1"></i> Mi Perfil
                        </a>
                    </li>
                </ul>
                <div class="d-flex align-items-center gap-2">
                    <span class="text-white-50 small d-none d-lg-inline">
                        <i class="bi bi-person-badge me-1"></i>${sessionScope.correo}
                    </span>
                    <a href="${ctx}/LogoutServlet" class="btn btn-outline-light btn-nav">
                        <i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesion
                    </a>
                </div>
            </c:if>

            <%-- ================= AGENTE INMOBILIARIA ================= --%>
            <c:if test="${rol == 'INMOBILIARIA'}">
                <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/dashboard/agente/index.jsp">
                            <i class="bi bi-speedometer2 me-1"></i> Panel Agente
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/index">
                            <i class="bi bi-house-door me-1"></i> Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/buscar">
                            <i class="bi bi-collection me-1"></i> Catalogo
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/PropiedadServlet?action=list">
                            <i class="bi bi-house-heart me-1"></i> Mis Propiedades
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/PropiedadServlet?action=new">
                            <i class="bi bi-plus-circle me-1"></i> Nueva Propiedad
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/PerfilServlet">
                            <i class="bi bi-person-circle me-1"></i> Mi Perfil
                        </a>
                    </li>
                </ul>
                <div class="d-flex align-items-center gap-2">
                    <span class="text-white-50 small d-none d-lg-inline">
                        <i class="bi bi-person-badge me-1"></i>${sessionScope.correo}
                    </span>
                    <a href="${ctx}/LogoutServlet" class="btn btn-outline-light btn-nav">
                        <i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesion
                    </a>
                </div>
            </c:if>

            <%-- ================= ADMINISTRADOR ================= --%>
            <c:if test="${rol == 'ADMINISTRADOR'}">
                <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/dashboard/admin/index.jsp">
                            <i class="bi bi-speedometer2 me-1"></i> Panel Admin
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/index">
                            <i class="bi bi-house-door me-1"></i> Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/buscar">
                            <i class="bi bi-collection me-1"></i> Catalogo
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/dashboard/admin/index.jsp#usuarios">
                            <i class="bi bi-people me-1"></i> Gestionar Usuarios
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/dashboard/admin/index.jsp#parametros">
                            <i class="bi bi-sliders me-1"></i> Parametros
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${ctx}/PerfilServlet">
                            <i class="bi bi-person-circle me-1"></i> Mi Perfil
                        </a>
                    </li>
                </ul>
                <div class="d-flex align-items-center gap-2">
                    <span class="text-white-50 small d-none d-lg-inline">
                        <i class="bi bi-person-badge me-1"></i>${sessionScope.correo}
                    </span>
                    <a href="${ctx}/LogoutServlet" class="btn btn-outline-light btn-nav">
                        <i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesion
                    </a>
                </div>
            </c:if>

        </div>
    </div>
</nav>
