<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:if test="${empty sessionScope.idUsuario}">
    <c:redirect url="${pageContext.request.contextPath}/LoginServlet"/>
</c:if>
<c:if test="${sessionScope.rol != 'ADMINISTRADOR'}">
    <c:redirect url="${pageContext.request.contextPath}/acceso_denegado.jsp"/>
</c:if>
<c:set var="tituloPagina" value="Gestion de Usuarios - JSGE In-Mobiliaria" scope="request"/>
<%@ include file="/includes/header.jsp"%>

<style>
    .table-card { border: none; border-radius: var(--radius-md); box-shadow: var(--shadow-sm); }
    .table thead th { background: #0B2545; color: #fff; font-weight: 600; white-space: nowrap; }
</style>

<div class="container" style="padding-top:120px; padding-bottom:3rem;">

    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h2 class="mb-1" style="color:#0B2545;">
                <i class="bi bi-people-fill me-2" style="color:var(--gold);"></i>Gestion de Usuarios
            </h2>
            <p class="text-muted mb-0">Administra el rol y el estado de las cuentas del sistema.</p>
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

    <!-- Filtro por rol -->
    <div class="card table-card mb-3">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/AdminUsuarioServlet" method="get"
                  class="row g-2 align-items-end">
                <div class="col-md-4">
                    <label for="rol" class="form-label fw-semibold mb-1">Filtrar por rol</label>
                    <select name="rol" id="rol" class="form-select" onchange="this.form.submit()">
                        <option value="">Todos los roles</option>
                        <c:forEach var="r" items="${roles}">
                            <option value="${r.key}" ${filtroRol == r.key ? 'selected' : ''}>${r.value}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-gold">
                        <i class="bi bi-funnel me-1"></i> Filtrar
                    </button>
                    <a href="${pageContext.request.contextPath}/AdminUsuarioServlet"
                       class="btn btn-outline-secondary">Limpiar</a>
                </div>
                <div class="col-md-5 text-md-end">
                    <span class="text-muted small">
                        <i class="bi bi-people me-1"></i>${fn:length(usuarios)} usuario(s)
                    </span>
                </div>
            </form>
        </div>
    </div>

    <div class="card table-card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Correo</th>
                            <th class="text-center">Rol</th>
                            <th class="text-center">Estado</th>
                            <th>Registro</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty usuarios}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                        No hay usuarios que coincidan con el filtro.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="u" items="${usuarios}">
                                    <tr>
                                        <td>${u.idUsuario}</td>
                                        <td class="fw-semibold">${u.correo}</td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${u.nombreRol == 'ADMINISTRADOR'}">
                                                    <span class="badge bg-danger">${u.nombreRol}</span>
                                                </c:when>
                                                <c:when test="${u.nombreRol == 'INMOBILIARIA'}">
                                                    <span class="badge bg-primary">${u.nombreRol}</span>
                                                </c:when>
                                                <c:when test="${u.nombreRol == 'CLIENTE'}">
                                                    <span class="badge bg-secondary">${u.nombreRol}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning text-dark">${u.nombreRol}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${u.estado}">
                                                    <span class="badge bg-success">Activo</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Bloqueado</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-muted small">${u.fechaRegistro}</td>
                                        <td class="text-center" style="white-space:nowrap;">
                                            <button type="button" class="btn btn-sm btn-outline-primary"
                                                    data-bs-toggle="modal" data-bs-target="#modalRol"
                                                    data-id="${u.idUsuario}"
                                                    data-correo="${u.correo}"
                                                    data-rol="${u.idRol}" title="Cambiar rol">
                                                <i class="bi bi-person-gear"></i> Rol
                                            </button>
                                            <form action="${pageContext.request.contextPath}/AdminUsuarioServlet"
                                                  method="post" class="d-inline">
                                                <input type="hidden" name="action" value="cambiarEstado">
                                                <input type="hidden" name="idUsuario" value="${u.idUsuario}">
                                                <input type="hidden" name="activo" value="${u.estado ? 'false' : 'true'}">
                                                <button type="submit"
                                                        class="btn btn-sm ${u.estado ? 'btn-outline-danger' : 'btn-outline-success'}"
                                                        onclick="return confirm('${u.estado ? '¿Bloquear' : '¿Activar'} la cuenta ${u.correo}?');">
                                                    <i class="bi ${u.estado ? 'bi-lock' : 'bi-unlock'} me-1"></i>
                                                    ${u.estado ? 'Bloquear' : 'Activar'}
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

<!-- Modal cambiar rol -->
<div class="modal fade" id="modalRol" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <form action="${pageContext.request.contextPath}/AdminUsuarioServlet" method="post" class="modal-content">
            <input type="hidden" name="action" value="cambiarRol">
            <input type="hidden" name="idUsuario" id="rolIdUsuario">

            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-person-gear text-gold me-2"></i>Cambiar rol</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body">
                <p class="mb-3">Usuario: <strong id="rolCorreo"></strong></p>
                <label for="rolSelect" class="form-label fw-semibold">Nuevo rol</label>
                <select name="idRol" id="rolSelect" class="form-select" required>
                    <c:forEach var="r" items="${roles}">
                        <option value="${r.key}">${r.value}</option>
                    </c:forEach>
                </select>
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
    var modalRol = document.getElementById('modalRol');
    modalRol.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        document.getElementById('rolIdUsuario').value = button.getAttribute('data-id');
        document.getElementById('rolCorreo').textContent = button.getAttribute('data-correo');
        var rolActual = button.getAttribute('data-rol');
        var select = document.getElementById('rolSelect');
        if (rolActual) {
            select.value = rolActual;
        }
    });
</script>
</body>
</html>
