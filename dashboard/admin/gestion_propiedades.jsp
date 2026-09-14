<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:if test="${empty sessionScope.idUsuario}">
    <c:redirect url="${pageContext.request.contextPath}/LoginServlet"/>
</c:if>
<c:if test="${sessionScope.rol != 'ADMINISTRADOR'}">
    <c:redirect url="${pageContext.request.contextPath}/acceso_denegado.jsp"/>
</c:if>
<c:if test="${empty tituloPagina}">
    <c:set var="tituloPagina" value="Gestion de Propiedades - JSGE In-Mobiliaria" scope="request"/>
</c:if>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="filtro" value="${empty filtroEstado ? 'todas' : filtroEstado}"/>
<%@ include file="/includes/header.jsp"%>

<style>
    .table-card { border: none; border-radius: var(--radius-md); box-shadow: var(--shadow-sm); }
    .table thead th { background: #0B2545; color: #fff; font-weight: 600; white-space: nowrap; }
</style>

<div class="container" style="padding-top:120px; padding-bottom:3rem;">

    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h2 class="mb-1" style="color:#0B2545;">
                <i class="bi bi-house-gear-fill me-2" style="color:var(--gold);"></i>Gestion de Propiedades
            </h2>
            <p class="text-muted mb-0">Administra el estado de todas las propiedades del sistema.</p>
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

    <!-- Filtro por estado -->
    <div class="card table-card mb-3">
        <div class="card-body">
            <form action="${ctx}/AdminPropiedadServlet" method="get" class="row g-2 align-items-end">
                <div class="col-md-4">
                    <label for="estado" class="form-label fw-semibold mb-1">Filtrar por estado</label>
                    <select name="estado" id="estado" class="form-select" onchange="this.form.submit()">
                        <option value="todas" ${filtro == 'todas' ? 'selected' : ''}>Todas</option>
                        <option value="activas" ${filtro == 'activas' ? 'selected' : ''}>Activas</option>
                        <option value="inactivas" ${filtro == 'inactivas' ? 'selected' : ''}>Inactivas</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-gold"><i class="bi bi-funnel me-1"></i> Filtrar</button>
                    <a href="${ctx}/AdminPropiedadServlet" class="btn btn-outline-secondary">Limpiar</a>
                </div>
                <div class="col-md-5 text-md-end">
                    <span class="text-muted small">
                        <i class="bi bi-house-door me-1"></i>${fn:length(propiedades)} propiedad(es)
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
                            <th>Matricula</th>
                            <th>Titulo</th>
                            <th>Tipo</th>
                            <th>Ciudad</th>
                            <th>Inmobiliaria</th>
                            <th class="text-end">Precio</th>
                            <th class="text-center">Estado</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty propiedades}">
                                <tr>
                                    <td colspan="9" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                        No hay propiedades que coincidan con el filtro.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="p" items="${propiedades}">
                                    <tr>
                                        <td>${p.idPropiedad}</td>
                                        <td class="fw-semibold">${p.matriculaInmobiliaria}</td>
                                        <td>${p.titulo}</td>
                                        <td><span class="badge text-bg-light border">${p.nombreTipo}</span></td>
                                        <td>${p.nombreCiudad}</td>
                                        <td class="text-muted small">${p.correoInmobiliaria}</td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${p.precio}" type="currency"
                                                              currencySymbol="$" maxFractionDigits="0"/>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${p.estadoLogico}">
                                                    <span class="badge bg-success">Activa</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Inactiva</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center" style="white-space:nowrap;">
                                            <c:if test="${p.estadoLogico}">
                                                <a href="${ctx}/propiedad?id=${p.idPropiedad}" target="_blank"
                                                   class="btn btn-sm btn-outline-secondary" title="Ver detalle">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                            </c:if>
                                            <form action="${ctx}/AdminPropiedadServlet" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="cambiarEstado">
                                                <input type="hidden" name="idPropiedad" value="${p.idPropiedad}">
                                                <input type="hidden" name="estado" value="${filtro}">
                                                <input type="hidden" name="activo" value="${p.estadoLogico ? 'false' : 'true'}">
                                                <button type="submit"
                                                        class="btn btn-sm ${p.estadoLogico ? 'btn-outline-danger' : 'btn-outline-success'}"
                                                        onclick="return confirm('${p.estadoLogico ? '¿Desactivar' : '¿Activar'} la propiedad ${p.matriculaInmobiliaria}?');">
                                                    <i class="bi ${p.estadoLogico ? 'bi-toggle-off' : 'bi-toggle-on'} me-1"></i>
                                                    ${p.estadoLogico ? 'Desactivar' : 'Activar'}
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
