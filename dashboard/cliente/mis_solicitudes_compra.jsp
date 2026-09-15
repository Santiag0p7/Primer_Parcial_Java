<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:if test="${empty sessionScope.idUsuario}">
    <c:redirect url="${pageContext.request.contextPath}/LoginServlet"/>
</c:if>
<c:if test="${sessionScope.rol != 'CLIENTE'}">
    <c:redirect url="${pageContext.request.contextPath}/acceso_denegado.jsp"/>
</c:if>
<c:if test="${empty tituloPagina}">
    <c:set var="tituloPagina" value="Mis Solicitudes - JSGE In-Mobiliaria" scope="request"/>
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
                <i class="bi bi-file-earmark-text-fill me-2" style="color:var(--gold);"></i>Mis Solicitudes
            </h2>
            <p class="text-muted mb-0">Tramites de compra o arriendo y sus documentos.</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${ctx}/buscar" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-search me-1"></i> Buscar propiedades
            </a>
            <a href="${ctx}/DashboardServlet" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left me-1"></i> Volver al panel
            </a>
        </div>
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
                    <i class="bi bi-file-earmark-plus fs-1 text-muted d-block mb-3"></i>
                    <h5 class="text-muted">Aun no has radicado solicitudes.</h5>
                    <p class="text-muted">Abre una propiedad y usa el boton "Solicitar compra / arriendo".</p>
                    <a href="${ctx}/buscar" class="btn btn-gold mt-2"><i class="bi bi-collection me-1"></i> Ir al catalogo</a>
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
                                    <th>Propiedad</th>
                                    <th class="text-center">Tipo</th>
                                    <th class="text-end">Monto oferta</th>
                                    <th>Fecha</th>
                                    <th class="text-center">Estado</th>
                                    <th class="text-center">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="s" items="${solicitudes}">
                                    <tr>
                                        <td>${s.idSolicitud}</td>
                                        <td class="fw-semibold">${s.tituloPropiedad}
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
                                        <td class="text-muted small">${s.fechaCreacion}</td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${s.estado == 'PENDIENTE'}"><span class="badge bg-warning text-dark">Pendiente</span></c:when>
                                                <c:when test="${s.estado == 'EN_REVISION'}"><span class="badge bg-info text-dark">En revision</span></c:when>
                                                <c:when test="${s.estado == 'APROBADA'}"><span class="badge bg-success">Aprobada</span></c:when>
                                                <c:when test="${s.estado == 'RECHAZADA'}"><span class="badge bg-danger">Rechazada</span></c:when>
                                                <c:otherwise><span class="badge bg-secondary">Cancelada</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center" style="white-space:nowrap;">
                                            <button type="button" class="btn btn-sm btn-outline-primary"
                                                    data-bs-toggle="modal" data-bs-target="#doc${s.idSolicitud}">
                                                <i class="bi bi-folder2-open"></i> Documentos
                                                <span class="badge text-bg-secondary ms-1">${fn:length(documentos[s.idSolicitud])}</span>
                                            </button>
                                            <c:if test="${s.estado == 'PENDIENTE' || s.estado == 'EN_REVISION'}">
                                                <form action="${ctx}/SolicitudCompraServlet" method="post" class="d-inline">
                                                    <input type="hidden" name="action" value="cancelar">
                                                    <input type="hidden" name="idSolicitud" value="${s.idSolicitud}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger"
                                                            onclick="return confirm('¿Cancelar esta solicitud?');">
                                                        <i class="bi bi-x-circle"></i>
                                                    </button>
                                                </form>
                                            </c:if>
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

<!-- Modales de documentos (uno por solicitud) -->
<c:forEach var="s" items="${solicitudes}">
    <div class="modal fade" id="doc${s.idSolicitud}" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-folder2-open text-gold me-2"></i>Documentos - Solicitud #${s.idSolicitud}
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <c:if test="${not empty s.observacion}">
                        <div class="alert alert-secondary small">
                            <strong>Observacion de la inmobiliaria:</strong> ${s.observacion}
                        </div>
                    </c:if>

                    <h6 class="fw-bold">Documentos radicados</h6>
                    <c:choose>
                        <c:when test="${empty documentos[s.idSolicitud]}">
                            <p class="text-muted small">Aun no has radicado documentos.</p>
                        </c:when>
                        <c:otherwise>
                            <ul class="list-group mb-3">
                                <c:forEach var="d" items="${documentos[s.idSolicitud]}">
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        <span>
                                            <i class="bi bi-file-earmark-text text-gold me-1"></i>
                                            <strong>${d.tipo}</strong> - ${d.nombre}
                                            <a href="${d.urlDocumento}" target="_blank" class="ms-2 small">ver</a>
                                        </span>
                                        <form action="${ctx}/SolicitudCompraServlet" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="eliminarDocumento">
                                            <input type="hidden" name="idDocumento" value="${d.idDocumento}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger"
                                                    onclick="return confirm('¿Eliminar este documento?');">
                                                <i class="bi bi-trash3"></i>
                                            </button>
                                        </form>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${s.estado == 'APROBADA' || s.estado == 'RECHAZADA'}">
                            <p class="text-muted small mb-0">La solicitud ya fue resuelta; no admite mas documentos.</p>
                        </c:when>
                        <c:otherwise>
                            <h6 class="fw-bold">Radicar nuevo documento</h6>
                            <form action="${ctx}/SolicitudCompraServlet" method="post" class="row g-2">
                                <input type="hidden" name="action" value="agregarDocumento">
                                <input type="hidden" name="idSolicitud" value="${s.idSolicitud}">
                                <div class="col-md-4">
                                    <label class="form-label small mb-1">Tipo</label>
                                    <select name="tipoDocumento" class="form-select form-select-sm">
                                        <option value="CEDULA">Cedula</option>
                                        <option value="INGRESOS">Certificado de ingresos</option>
                                        <option value="ESCRITURA">Escritura</option>
                                        <option value="EXTRACTOS">Extractos bancarios</option>
                                        <option value="OTRO">Otro</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label small mb-1">Nombre *</label>
                                    <input type="text" name="nombreDocumento" class="form-control form-control-sm" maxlength="150" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label small mb-1">URL del documento *</label>
                                    <input type="url" name="urlDocumento" class="form-control form-control-sm" required
                                           placeholder="https://...">
                                </div>
                                <div class="col-12 text-end">
                                    <button type="submit" class="btn btn-gold btn-sm">
                                        <i class="bi bi-upload me-1"></i> Radicar documento
                                    </button>
                                </div>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</c:forEach>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
