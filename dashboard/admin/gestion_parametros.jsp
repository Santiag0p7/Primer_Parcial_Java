<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:if test="${empty sessionScope.idUsuario}">
    <c:redirect url="${pageContext.request.contextPath}/LoginServlet"/>
</c:if>
<c:if test="${sessionScope.rol != 'ADMINISTRADOR'}">
    <c:redirect url="${pageContext.request.contextPath}/acceso_denegado.jsp"/>
</c:if>
<c:set var="tituloPagina" value="Parametros del Sistema - JSGE In-Mobiliaria" scope="request"/>
<%@ include file="/includes/header.jsp"%>

<c:set var="tabSel" value="${empty tabActivo ? 'ciudades' : tabActivo}"/>

<style>
    .table-card { border: none; border-radius: var(--radius-md); box-shadow: var(--shadow-sm); }
    .table thead th { background: #0B2545; color: #fff; font-weight: 600; white-space: nowrap; }
    .nav-tabs .nav-link { color: #0B2545; font-weight: 600; }
    .nav-tabs .nav-link.active { color: var(--gold-dark); border-bottom-color: var(--gold); }
    .param-form-card { border: none; border-radius: var(--radius-md); box-shadow: var(--shadow-sm); background: #F8F9FA; }
</style>

<div class="container" style="padding-top:120px; padding-bottom:3rem;">

    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h2 class="mb-1" style="color:#0B2545;">
                <i class="bi bi-sliders me-2" style="color:var(--gold);"></i>Mantenimiento de Parametros
            </h2>
            <p class="text-muted mb-0">Administra Ciudades, Tipos de Propiedad y Caracteristicas del sistema.</p>
        </div>
        <a href="${pageContext.request.contextPath}/DashboardServlet" class="btn btn-outline-secondary btn-sm">
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

    <ul class="nav nav-tabs mb-3" id="tabsParametros" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link ${tabSel == 'ciudades' ? 'active' : ''}" id="tab-ciudades-btn" data-bs-toggle="tab"
                    data-bs-target="#tab-ciudades" type="button" role="tab">
                <i class="bi bi-geo-alt me-1"></i> Ciudades
                <span class="badge bg-secondary ms-1">${fn:length(ciudades)}</span>
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link ${tabSel == 'tipos' ? 'active' : ''}" id="tab-tipos-btn" data-bs-toggle="tab"
                    data-bs-target="#tab-tipos" type="button" role="tab">
                <i class="bi bi-house-door me-1"></i> Tipos de Propiedad
                <span class="badge bg-secondary ms-1">${fn:length(tipos)}</span>
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link ${tabSel == 'caracteristicas' ? 'active' : ''}" id="tab-caracteristicas-btn" data-bs-toggle="tab"
                    data-bs-target="#tab-caracteristicas" type="button" role="tab">
                <i class="bi bi-check2-square me-1"></i> Caracteristicas
                <span class="badge bg-secondary ms-1">${fn:length(caracteristicas)}</span>
            </button>
        </li>
    </ul>

    <div class="tab-content" id="tabsParametrosContent">

        <!-- ================== CIUDADES ================== -->
        <div class="tab-pane fade ${tabSel == 'ciudades' ? 'show active' : ''}" id="tab-ciudades" role="tabpanel">
            <div class="card param-form-card mb-3">
                <div class="card-body">
                    <h6 class="fw-bold mb-3"><i class="bi bi-plus-circle me-1 text-gold"></i>Nueva ciudad</h6>
                    <form action="${pageContext.request.contextPath}/AdminParametrosServlet" method="post"
                          class="row g-2 align-items-end">
                        <input type="hidden" name="entidad" value="ciudad">
                        <input type="hidden" name="operacion" value="crear">
                        <input type="hidden" name="tab" value="ciudades">
                        <div class="col-md-5">
                            <label class="form-label fw-semibold mb-1">Nombre *</label>
                            <input type="text" name="nombre" class="form-control" maxlength="80" required
                                   placeholder="Ej: Barrancabermeja">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold mb-1">Departamento</label>
                            <input type="text" name="departamento" class="form-control" maxlength="80"
                                   placeholder="Ej: Santander">
                        </div>
                        <div class="col-md-3">
                            <button type="submit" class="btn btn-gold w-100">
                                <i class="bi bi-plus-lg me-1"></i> Agregar
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card table-card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead><tr><th>#</th><th>Nombre</th><th>Departamento</th>
                                <th class="text-center">Acciones</th></tr></thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty ciudades}">
                                        <tr><td colspan="4" class="text-center py-4 text-muted">Sin ciudades registradas.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="ci" items="${ciudades}" varStatus="st">
                                            <tr>
                                                <td>${st.index + 1}</td>
                                                <td class="fw-semibold">${ci.nombre}</td>
                                                <td>${ci.departamento}</td>
                                                <td class="text-center" style="white-space:nowrap;">
                                                    <button type="button" class="btn btn-sm btn-outline-primary"
                                                            data-bs-toggle="modal" data-bs-target="#modalEditCiudad"
                                                            data-id="${ci.idCiudad}" data-nombre="${ci.nombre}"
                                                            data-departamento="${ci.departamento}">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </button>
                                                    <form action="${pageContext.request.contextPath}/AdminParametrosServlet"
                                                          method="post" class="d-inline">
                                                        <input type="hidden" name="entidad" value="ciudad">
                                                        <input type="hidden" name="operacion" value="eliminar">
                                                        <input type="hidden" name="tab" value="ciudades">
                                                        <input type="hidden" name="id" value="${ci.idCiudad}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger"
                                                                onclick="return confirm('¿Eliminar la ciudad ${ci.nombre}?');">
                                                            <i class="bi bi-trash3"></i>
                                                        </button>
                                                    </form>
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
        </div>

        <!-- ================== TIPOS ================== -->
        <div class="tab-pane fade ${tabSel == 'tipos' ? 'show active' : ''}" id="tab-tipos" role="tabpanel">
            <div class="card param-form-card mb-3">
                <div class="card-body">
                    <h6 class="fw-bold mb-3"><i class="bi bi-plus-circle me-1 text-gold"></i>Nuevo tipo de propiedad</h6>
                    <form action="${pageContext.request.contextPath}/AdminParametrosServlet" method="post"
                          class="row g-2 align-items-end">
                        <input type="hidden" name="entidad" value="tipo">
                        <input type="hidden" name="operacion" value="crear">
                        <input type="hidden" name="tab" value="tipos">
                        <div class="col-md-9">
                            <label class="form-label fw-semibold mb-1">Nombre *</label>
                            <input type="text" name="nombre" class="form-control" maxlength="80" required
                                   placeholder="Ej: Bodega">
                        </div>
                        <div class="col-md-3">
                            <button type="submit" class="btn btn-gold w-100">
                                <i class="bi bi-plus-lg me-1"></i> Agregar
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card table-card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead><tr><th>#</th><th>Nombre</th><th class="text-center">Acciones</th></tr></thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty tipos}">
                                        <tr><td colspan="3" class="text-center py-4 text-muted">Sin tipos registrados.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="t" items="${tipos}" varStatus="st">
                                            <tr>
                                                <td>${st.index + 1}</td>
                                                <td class="fw-semibold">${t.nombre}</td>
                                                <td class="text-center" style="white-space:nowrap;">
                                                    <button type="button" class="btn btn-sm btn-outline-primary"
                                                            data-bs-toggle="modal" data-bs-target="#modalEditTipo"
                                                            data-id="${t.idTipo}" data-nombre="${t.nombre}">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </button>
                                                    <form action="${pageContext.request.contextPath}/AdminParametrosServlet"
                                                          method="post" class="d-inline">
                                                        <input type="hidden" name="entidad" value="tipo">
                                                        <input type="hidden" name="operacion" value="eliminar">
                                                        <input type="hidden" name="tab" value="tipos">
                                                        <input type="hidden" name="id" value="${t.idTipo}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger"
                                                                onclick="return confirm('¿Eliminar el tipo ${t.nombre}?');">
                                                            <i class="bi bi-trash3"></i>
                                                        </button>
                                                    </form>
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
        </div>

        <!-- ================== CARACTERISTICAS ================== -->
        <div class="tab-pane fade ${tabSel == 'caracteristicas' ? 'show active' : ''}" id="tab-caracteristicas" role="tabpanel">
            <div class="card param-form-card mb-3">
                <div class="card-body">
                    <h6 class="fw-bold mb-3"><i class="bi bi-plus-circle me-1 text-gold"></i>Nueva caracteristica</h6>
                    <form action="${pageContext.request.contextPath}/AdminParametrosServlet" method="post"
                          class="row g-2 align-items-end">
                        <input type="hidden" name="entidad" value="caracteristica">
                        <input type="hidden" name="operacion" value="crear">
                        <input type="hidden" name="tab" value="caracteristicas">
                        <div class="col-md-9">
                            <label class="form-label fw-semibold mb-1">Nombre *</label>
                            <input type="text" name="nombre" class="form-control" maxlength="80" required
                                   placeholder="Ej: Chimenea">
                        </div>
                        <div class="col-md-3">
                            <button type="submit" class="btn btn-gold w-100">
                                <i class="bi bi-plus-lg me-1"></i> Agregar
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card table-card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead><tr><th>#</th><th>Nombre</th><th class="text-center">Acciones</th></tr></thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty caracteristicas}">
                                        <tr><td colspan="3" class="text-center py-4 text-muted">Sin caracteristicas registradas.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="ca" items="${caracteristicas}" varStatus="st">
                                            <tr>
                                                <td>${st.index + 1}</td>
                                                <td class="fw-semibold">${ca.nombre}</td>
                                                <td class="text-center" style="white-space:nowrap;">
                                                    <button type="button" class="btn btn-sm btn-outline-primary"
                                                            data-bs-toggle="modal" data-bs-target="#modalEditCaracteristica"
                                                            data-id="${ca.idCaracteristica}" data-nombre="${ca.nombre}">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </button>
                                                    <form action="${pageContext.request.contextPath}/AdminParametrosServlet"
                                                          method="post" class="d-inline">
                                                        <input type="hidden" name="entidad" value="caracteristica">
                                                        <input type="hidden" name="operacion" value="eliminar">
                                                        <input type="hidden" name="tab" value="caracteristicas">
                                                        <input type="hidden" name="id" value="${ca.idCaracteristica}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger"
                                                                onclick="return confirm('¿Eliminar la caracteristica ${ca.nombre}?');">
                                                            <i class="bi bi-trash3"></i>
                                                        </button>
                                                    </form>
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
        </div>
    </div>
</div>

<!-- ============ Modales de edicion ============ -->
<div class="modal fade" id="modalEditCiudad" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form action="${pageContext.request.contextPath}/AdminParametrosServlet" method="post" class="modal-content">
            <input type="hidden" name="entidad" value="ciudad">
            <input type="hidden" name="operacion" value="actualizar">
            <input type="hidden" name="tab" value="ciudades">
            <input type="hidden" name="id" id="ciudadId">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-pencil-square text-gold me-2"></i>Editar ciudad</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label fw-semibold">Nombre *</label>
                    <input type="text" name="nombre" id="ciudadNombre" class="form-control" maxlength="80" required>
                </div>
                <div class="mb-0">
                    <label class="form-label fw-semibold">Departamento</label>
                    <input type="text" name="departamento" id="ciudadDepartamento" class="form-control" maxlength="80">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="btn btn-gold"><i class="bi bi-save me-1"></i> Guardar</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="modalEditTipo" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form action="${pageContext.request.contextPath}/AdminParametrosServlet" method="post" class="modal-content">
            <input type="hidden" name="entidad" value="tipo">
            <input type="hidden" name="operacion" value="actualizar">
            <input type="hidden" name="tab" value="tipos">
            <input type="hidden" name="id" id="tipoId">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-pencil-square text-gold me-2"></i>Editar tipo de propiedad</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body">
                <label class="form-label fw-semibold">Nombre *</label>
                <input type="text" name="nombre" id="tipoNombre" class="form-control" maxlength="80" required>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="btn btn-gold"><i class="bi bi-save me-1"></i> Guardar</button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="modalEditCaracteristica" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form action="${pageContext.request.contextPath}/AdminParametrosServlet" method="post" class="modal-content">
            <input type="hidden" name="entidad" value="caracteristica">
            <input type="hidden" name="operacion" value="actualizar">
            <input type="hidden" name="tab" value="caracteristicas">
            <input type="hidden" name="id" id="caracteristicaId">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-pencil-square text-gold me-2"></i>Editar caracteristica</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body">
                <label class="form-label fw-semibold">Nombre *</label>
                <input type="text" name="nombre" id="caracteristicaNombre" class="form-control" maxlength="80" required>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="btn btn-gold"><i class="bi bi-save me-1"></i> Guardar</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('modalEditCiudad').addEventListener('show.bs.modal', function (event) {
        var b = event.relatedTarget;
        document.getElementById('ciudadId').value = b.getAttribute('data-id');
        document.getElementById('ciudadNombre').value = b.getAttribute('data-nombre');
        document.getElementById('ciudadDepartamento').value = b.getAttribute('data-departamento') || '';
    });
    document.getElementById('modalEditTipo').addEventListener('show.bs.modal', function (event) {
        var b = event.relatedTarget;
        document.getElementById('tipoId').value = b.getAttribute('data-id');
        document.getElementById('tipoNombre').value = b.getAttribute('data-nombre');
    });
    document.getElementById('modalEditCaracteristica').addEventListener('show.bs.modal', function (event) {
        var b = event.relatedTarget;
        document.getElementById('caracteristicaId').value = b.getAttribute('data-id');
        document.getElementById('caracteristicaNombre').value = b.getAttribute('data-nombre');
    });
</script>
</body>
</html>
