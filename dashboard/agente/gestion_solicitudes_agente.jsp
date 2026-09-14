<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:if test="${empty sessionScope.idUsuario}">
    <c:redirect url="${pageContext.request.contextPath}/LoginServlet"/>
</c:if>
<c:if test="${sessionScope.rol != 'INMOBILIARIA'}">
    <c:redirect url="${pageContext.request.contextPath}/acceso_denegado.jsp"/>
</c:if>
<c:set var="tituloPagina" value="Solicitudes Recibidas - Inmobiliaria UTS" scope="request"/>
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
                <i class="bi bi-calendar2-week-fill me-2" style="color:var(--gold);"></i>Solicitudes de Visita Recibidas
            </h2>
            <p class="text-muted mb-0">Confirma, marca como realizada o rechaza las citas de tus inmuebles.</p>
        </div>
        <a href="${pageContext.request.contextPath}/PropiedadServlet?action=list" class="btn btn-outline-secondary">
            <i class="bi bi-house-door me-1"></i> Mis Propiedades
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
                            <th>Cliente</th>
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
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                        No has recibido solicitudes de visita todavia.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="sol" items="${solicitudes}">
                                    <tr>
                                        <td>${sol.idSolicitud}</td>
                                        <td>
                                            <div class="fw-semibold">${sol.nombreCliente}</div>
                                            <small class="text-muted">${sol.correoCliente}</small>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/propiedad?id=${sol.idPropiedad}"
                                               class="text-decoration-none">${sol.tituloPropiedad}</a>
                                        </td>
                                        <td>${sol.fechaVisita}</td>
                                        <td>${sol.horaVisita}</td>
                                        <td class="text-muted small" style="max-width:240px;">
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
                                            <c:if test="${sol.estado == 'PENDIENTE'}">
                                                <a href="${pageContext.request.contextPath}/SolicitudServlet?action=updateStatus&id=${sol.idSolicitud}&estado=CONFIRMADA"
                                                   class="btn btn-sm btn-success" title="Confirmar cita">
                                                    <i class="bi bi-check2-circle me-1"></i> Confirmar
                                                </a>
                                                <a href="${pageContext.request.contextPath}/SolicitudServlet?action=updateStatus&id=${sol.idSolicitud}&estado=CANCELADA"
                                                   class="btn btn-sm btn-outline-danger"
                                                   onclick="return confirm('¿Rechazar esta solicitud de visita?');"
                                                   title="Rechazar cita">
                                                    <i class="bi bi-x-circle me-1"></i> Rechazar
                                                </a>
                                            </c:if>
                                            <c:if test="${sol.estado == 'CONFIRMADA'}">
                                                <a href="${pageContext.request.contextPath}/SolicitudServlet?action=updateStatus&id=${sol.idSolicitud}&estado=REALIZADA"
                                                   class="btn btn-sm btn-primary" title="Marcar como realizada">
                                                    <i class="bi bi-flag me-1"></i> Realizada
                                                </a>
                                                <a href="${pageContext.request.contextPath}/SolicitudServlet?action=updateStatus&id=${sol.idSolicitud}&estado=CANCELADA"
                                                   class="btn btn-sm btn-outline-danger"
                                                   onclick="return confirm('¿Cancelar esta cita confirmada?');"
                                                   title="Cancelar cita">
                                                    <i class="bi bi-x-circle me-1"></i> Cancelar
                                                </a>
                                            </c:if>
                                            <c:if test="${sol.estado == 'REALIZADA' || sol.estado == 'CANCELADA'}">
                                                <span class="text-muted small">Finalizada</span>
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

    <p class="text-muted small mt-2 mb-0">
        <i class="bi bi-collection me-1"></i>${fn:length(solicitudes)} solicitud(es) en total.
    </p>

    <div class="mt-3">
        <a href="${pageContext.request.contextPath}/dashboard/agente/index.jsp"
           class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left me-1"></i> Volver al panel
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
