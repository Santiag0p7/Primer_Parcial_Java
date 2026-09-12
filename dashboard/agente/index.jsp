<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${empty sessionScope.idUsuario}">
    <c:redirect url="${pageContext.request.contextPath}/LoginServlet"/>
</c:if>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Agente - Inmobiliaria UTS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
    <style>
        .dashboard-nav { background: #0B2545; padding: 0.75rem 0; }
        .dashboard-welcome { padding: 3rem 0; min-height: 80vh; }
    </style>
</head>
<body>
    <nav class="dashboard-nav">
        <div class="container d-flex justify-content-between align-items-center">
            <span class="text-white fw-bold" style="font-family:'Playfair Display',serif;">
                <i class="bi bi-buildings-fill me-2" style="color:var(--gold);"></i>
                Inmobiliaria <span style="color:var(--gold);">UTS</span>
                <span class="badge bg-primary ms-2">INMOBILIARIA</span>
            </span>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline-light btn-sm">
                <i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesion
            </a>
        </div>
    </nav>
    <div class="dashboard-welcome">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8 text-center">
                    <div class="mb-4">
                        <i class="bi bi-person-badge-fill" style="font-size:4rem; color:var(--gold);"></i>
                    </div>
                    <h1 style="font-family:'Playfair Display',serif; color:#0B2545;">Panel de Agente Inmobiliario</h1>
                    <p class="text-muted fs-5 mt-3">
                        Bienvenido, <strong>${sessionScope.correo}</strong>.<br>
                        Gestiona las propiedades asignadas, atiende consultas de clientes y agenda visitas.
                    </p>
                    <div class="row g-4 mt-4">
                        <div class="col-md-4">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-body text-center">
                                    <i class="bi bi-house-door-fill fs-1" style="color:var(--gold);"></i>
                                    <h5 class="mt-2">Mis Propiedades</h5>
                                    <p class="text-muted small">Propiedades asignadas</p>
                                    <a href="${pageContext.request.contextPath}/PropiedadServlet?action=list"
                                       class="btn btn-gold btn-sm">
                                        <i class="bi bi-eye me-1"></i> Gestionar
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-body text-center">
                                    <i class="bi bi-chat-dots-fill fs-1" style="color:var(--gold);"></i>
                                    <h5 class="mt-2">Consultas</h5>
                                    <p class="text-muted small">Pendientes de respuesta</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-body text-center">
                                    <i class="bi bi-calendar-check-fill fs-1" style="color:var(--gold);"></i>
                                    <h5 class="mt-2">Visitas</h5>
                                    <p class="text-muted small">Citas programadas</p>
                                </div>
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
