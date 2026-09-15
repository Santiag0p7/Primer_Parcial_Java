<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:if test="${empty sessionScope.idUsuario}">
    <c:redirect url="${pageContext.request.contextPath}/LoginServlet"/>
</c:if>
<c:if test="${sessionScope.rol != 'INMOBILIARIA'}">
    <c:redirect url="${pageContext.request.contextPath}/acceso_denegado.jsp"/>
</c:if>
<c:if test="${empty tituloPagina}">
    <c:set var="tituloPagina" value="Solicitudes de Compra/Arriendo - JSGE In-Mobiliaria" scope="request"/>
</c:if>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%@ include file="/includes/header.jsp"%>

<style>
    .table-card { border: none; border-radius: var(--radius-md); box-shadow: var(--shadow-sm); }
    .table thead th { background: #0B2545; color: #fff; font-weight: 600; white-space: nowrap; }
</style>

<div class="container" style="padding-top:120px; padding-bottom:3rem;">

    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h2 class="mb-1" style="color:#0B2545;">
                <i class="bi bi-clipboard-check-fill me-2" style="color:var(--gold);"></i>Solicitudes de Compra / Arriendo
            </h2>
            <p class="text-muted mb-0">Revisa los documentos y aprueba o rechaza cada tramite.</p>
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
        <c:when test="${empty solicitudes}">
            <div class="card table-card">
                <div class="card-body text-center py-5">
                    <i class="bi bi-inbox fs-1 text-muted d-block mb-3"></i>
                    <h5 class="text-muted">No hay solicitudes recibidas.</h5>
                    <p class="text-muted mb-0">Cuando un cliente radique una compra o arriendo, aparecera aqui.</p>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card table-card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Cliente</th>
                                    <th>Propiedad</th>
                                    <th class="text-center">Tipo</th>
                                    <th class="text-end">Monto oferta</th>
                                    <th class="text-center">Documentos</th>
                                    <th class="text-center">Estado</th>
                                    <th class="text-center">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="s" items="${solicitudes}">
                                    <tr>
                                        <td>${s.idSolicitud}</td>
                                        <td class="fw-semibold">${s.nombreCliente}
                                            <div class="text-muted small">${s.correoCliente}</div>
                                        </td>
                                        <td>${s.tituloPropiedad}
                                            <div class="text-muted small">${s.nombreCiudad}</div>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge ${s.tipo == 'COMPRA' ? 'text-bg-primary' : 'text-bg-info'}">${s.tipo}</span>
                                        </td>
                                        <td class="text-end">
                                            <c:choose>
                                                <c:when test="${not empty s.montoOferta}">
                                                    <fmt:formatNumber value="${s.montoOferta}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge text-bg-secondary">${fn:length(documentos[s.idSolicitud])}</span>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${s.estado == 'PENDIENTE'}"><span class="badge bg-warning text-dark">Pendiente</span></c:when>
                                                <c:when test="${s.estado == 'EN_REVISION'}"><span class="badge bg-info text-dark">En revision</span></c:when>
                                                <c:when test="${s.estado == 'APROBADA'}"><span class="badge bg-success">Aprobada</span></c:when>
                                                <c:when test="${s.estado == 'RECHAZADA'}"><span class="badge bg-danger">Rechazada</span></c:when>
                                                <c:otherwise><span class="badge bg-secondary">Cancelada</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <button type="button" class="btn btn-sm btn-gold"
                                                    data-bs-toggle="modal" data-bs-target="#gestion${s.idSolicitud}">
                                                <i class="bi bi-clipboard-check me-1"></i> Revisar
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Modales de gestion (uno por solicitud) -->
<c:forEach var="s" items="${solicitudes}">
    <div class="modal fade" id="gestion${s.idSolicitud}" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-clipboard-check text-gold me-2"></i>Solicitud #${s.idSolicitud}
                        <span class="badge ${s.tipo == 'COMPRA' ? 'text-bg-primary' : 'text-bg-info'} ms-1">${s.tipo}</span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <p class="mb-1"><strong>Cliente:</strong> ${s.nombreCliente} (${s.correoCliente})</p>
                    <p class="mb-1"><strong>Propiedad:</strong> ${s.tituloPropiedad} - ${s.nombreCiudad}</p>
                    <c:if test="${not empty s.montoOferta}">
                        <p class="mb-1"><strong>Monto oferta:</strong>
                            <fmt:formatNumber value="${s.montoOferta}" type="currency" currencySymbol="$" maxFractionDigits="0"/>
                        </p>
                    </c:if>
                    <c:if test="${not empty s.mensaje}">
                        <p class="mb-3"><strong>Mensaje:</strong> ${s.mensaje}</p>
                    </c:if>

                    <h6 class="fw-bold">Documentos radicados</h6>
                    <c:choose>
                        <c:when test="${empty documentos[s.idSolicitud]}">
                            <p class="text-muted small">El cliente aun no ha radicado documentos.</p>
                        </c:when>
                        <c:otherwise>
                            <ul class="list-group mb-3">
                                <c:forEach var="d" items="${documentos[s.idSolicitud]}">
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        <span>
                                            <i class="bi bi-file-earmark-text text-gold me-1"></i>
                                            <strong>${d.tipo}</strong> - ${d.nombre}
                                        </span>
                                        <a href="${d.urlDocumento}" target="_blank" class="btn btn-sm btn-outline-secondary">
                                            <i class="bi bi-box-arrow-up-right"></i> Ver
                                        </a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:otherwise>
                    </c:choose>

                    <c:if test="${s.estado == 'CANCELADA'}">
                        <div class="alert alert-secondary small mb-0">El cliente cancelo esta solicitud.</div>
                    </c:if>

                    <c:if test="${s.estado != 'CANCELADA'}">
                        <hr>
                        <h6 class="fw-bold">Resolver solicitud</h6>
                        <form action="${ctx}/SolicitudCompraServlet" method="post" class="row g-2">
                            <input type="hidden" name="action" value="cambiarEstado">
                            <input type="hidden" name="idSolicitud" value="${s.idSolicitud}">
                            <div class="col-md-4">
                                <label class="form-label small mb-1">Nuevo estado</label>
                                <select name="estado" class="form-select form-select-sm" required>
                                    <option value="EN_REVISION" ${s.estado == 'EN_REVISION' ? 'selected' : ''}>En revision</option>
                                    <option value="APROBADA" ${s.estado == 'APROBADA' ? 'selected' : ''}>Aprobada</option>
                                    <option value="RECHAZADA" ${s.estado == 'RECHAZADA' ? 'selected' : ''}>Rechazada</option>
                                    <option value="PENDIENTE" ${s.estado == 'PENDIENTE' ? 'selected' : ''}>Pendiente</option>
                                </select>
                            </div>
                            <div class="col-md-8">
                                <label class="form-label small mb-1">Observacion (opcional)</label>
                                <input type="text" name="observacion" class="form-control form-control-sm" maxlength="500"
                                       value="${s.observacion}" placeholder="Motivo o comentario para el cliente">
                            </div>
                            <div class="col-12 text-end">
                                <button type="submit" class="btn btn-gold btn-sm">
                                    <i class="bi bi-save me-1"></i> Guardar estado
                                </button>
                            </div>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</c:forEach>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
