<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="tituloPagina" value="Acceso Denegado - Inmobiliaria UTS" scope="request"/>

<%@ include file="/includes/header.jspf"%>

    <style>
        body { min-height: 100vh; display: flex; align-items: center; justify-content: center;
               background: linear-gradient(135deg, #0B2545, #13315C, #134074); }
        .denied-card { background: #fff; border-radius: var(--radius-lg); box-shadow: var(--shadow-lg);
                       padding: 3.5rem; text-align: center; max-width: 520px; width: 100%; }
        .denied-icon { width: 100px; height: 100px;
                       background: linear-gradient(135deg, rgba(220, 53, 69, 0.1), rgba(220, 53, 69, 0.05));
                       border-radius: 50%; display: flex; align-items: center; justify-content: center;
                       margin: 0 auto 1.5rem; }
        .denied-icon i { font-size: 3rem; color: #dc3545; }
        .denied-code { font-family: 'Playfair Display', serif; font-size: 4rem; font-weight: 700; color: #dc3545; margin-bottom: 0.5rem; }
        .denied-title { font-family: 'Playfair Display', serif; font-size: 1.5rem; font-weight: 700; color: #0B2545; margin-bottom: 1rem; }
        .denied-text { color: #6c757d; margin-bottom: 2rem; line-height: 1.7; }
    </style>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="denied-card">
                    <div class="denied-icon">
                        <i class="bi bi-shield-x"></i>
                    </div>
                    <div class="denied-code">403</div>
                    <h1 class="denied-title">Acceso Denegado</h1>
                    <p class="denied-text">
                        No tienes permisos para acceder a esta pagina.<br>
                        <c:if test="${not empty rutaSolicitada}">
                            <small class="text-muted">Ruta: <code>${rutaSolicitada}</code></small>
                        </c:if>
                        <c:if test="${not empty rolActual}">
                            <br><small class="text-muted">Tu rol: <strong>${rolActual}</strong></small>
                        </c:if>
                    </p>
                    <div class="d-flex gap-3 justify-content-center flex-wrap">
                        <a href="${pageContext.request.contextPath}/index" class="btn btn-gold px-4">
                            <i class="bi bi-house me-2"></i> Ir al Inicio
                        </a>
                        <a href="javascript:history.back()" class="btn btn-outline-secondary px-4">
                            <i class="bi bi-arrow-left me-2"></i> Volver
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

<%@ include file="/includes/footer.jspf"%>
