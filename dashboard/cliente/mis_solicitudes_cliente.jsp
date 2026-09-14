<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${empty sessionScope.idUsuario}">
    <c:redirect url="${pageContext.request.contextPath}/LoginServlet"/>
</c:if>
<c:if test="${sessionScope.rol != 'CLIENTE'}">
    <c:redirect url="${pageContext.request.contextPath}/acceso_denegado.jsp"/>
</c:if>
<c:set var="tituloPagina" value="Mis Solicitudes - JSGE In-Mobiliaria" scope="request"/>
<%@ include file="/includes/header.jsp"%>

<style>
    .table-card { border: none; border-radius: var(--radius-md); box-shadow: var(--shadow-sm); }
    .table thead th { background: #0B2545; color: #fff; font-weight: 600; white-space: nowrap; }
    .badge-estado { font-weight: 600; }
</style>

<div class="container" style="padding-top:120px; padding-bottom:3rem;">

    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h2 class="mb-1" style="color:#0B2545;">
                <i class="bi bi-calendar-check-fill me-2" style="color:var(--gold);"></i>Mis Solicitudes de Visita
            </h2>
            <p class="text-muted mb-0">Historial de citas solicitadas sobre las propiedades.</p>
        </div>
        <a href="${pageContext.request.contextPath}/buscar" class="btn btn-gold">
            <i class="bi bi-search me-1"></i> Buscar propiedades
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

    <div class="card table-card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Propiedad</th>
                            <th>Fecha</th>
                            <th>Hora</th>
                            <th>Comentario</th>
                            <th class="text-center">Estado</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty solicitudes}">
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">
                                        <i class="bi bi-calendar-x fs-1 d-block mb-2"></i>
                                        Aun no has solicitado visitas.
                                        <a href="${pageContext.request.contextPath}/buscar">Explora el catalogo</a>.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="sol" items="${solicitudes}">
                                    <tr>
                                        <td>${sol.idSolicitud}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/propiedad?id=${sol.idPropiedad}"
                                               class="text-decoration-none fw-semibold">
                                                ${sol.tituloPropiedad}
                                            </a>
                                        </td>
                                        <td>${sol.fechaVisita}</td>
                                        <td>${sol.horaVisita}</td>
                                        <td class="text-muted small" style="max-width:280px;">
                                            <c:choose>
                                                <c:when test="${not empty sol.comentario}">${sol.comentario}</c:when>
                                                <c:otherwise>&mdash;</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${sol.estado == 'PENDIENTE'}">
                                                    <span class="badge bg-warning text-dark badge-estado">Pendiente</span>
                                                </c:when>
                                                <c:when test="${sol.estado == 'CONFIRMADA'}">
                                                    <span class="badge bg-success badge-estado">Confirmada</span>
                                                </c:when>
                                                <c:when test="${sol.estado == 'REALIZADA'}">
                                                    <span class="badge bg-primary badge-estado">Realizada</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary badge-estado">Cancelada</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center" style="white-space:nowrap;">
                                            <c:if test="${sol.estado == 'PENDIENTE' || sol.estado == 'CONFIRMADA'}">
                                                <a href="${pageContext.request.contextPath}/SolicitudServlet?action=updateStatus&id=${sol.idSolicitud}&estado=CANCELADA"
                                                   class="btn btn-sm btn-outline-danger"
                                                   onclick="return confirm('¿Cancelar esta solicitud de visita?');">
                                                    <i class="bi bi-x-circle me-1"></i> Cancelar
                                                </a>
                                            </c:if>
                                            <c:if test="${sol.estado == 'REALIZADA' || sol.estado == 'CANCELADA'}">
                                                <span class="text-muted small">Sin acciones</span>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="mt-3">
        <a href="${pageContext.request.contextPath}/dashboard/cliente/index.jsp"
           class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left me-1"></i> Volver al panel
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
