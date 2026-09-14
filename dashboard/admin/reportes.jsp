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
<c:set var="tituloPagina" value="Reportes - JSGE In-Mobiliaria" scope="request"/>
<%@ include file="/includes/header.jsp"%>

<style>
    .report-card { border: none; border-radius: var(--radius-md); box-shadow: var(--shadow-sm); }
    .report-card .card-header {
        background: #0B2545; color: #fff; font-weight: 600;
        border-radius: var(--radius-md) var(--radius-md) 0 0 !important;
    }
    .report-card .table thead th { background: #f1f3f5; color: #0B2545; font-weight: 600; white-space: nowrap; }
    .report-sql {
        font-family: Consolas, 'Courier New', monospace; font-size: 0.72rem;
        background: #0B2545; color: #d1e7dd; padding: 0.6rem 0.8rem;
        border-radius: var(--radius-sm); white-space: pre-wrap; word-break: break-word;
    }
</style>

<div class="container" style="padding-top:120px; padding-bottom:3rem;">

    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h2 class="mb-1" style="color:#0B2545;">
                <i class="bi bi-bar-chart-fill me-2" style="color:var(--gold);"></i>Reportes del Sistema
            </h2>
            <p class="text-muted mb-0">Consultas obligatorias: INNER JOIN (3+ tablas), LEFT JOIN y GROUP BY / HAVING.</p>
        </div>
        <a href="${pageContext.request.contextPath}/DashboardServlet" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left me-1"></i> Volver al panel
        </a>
    </div>

    <c:if test="${not empty errorReportes}">
        <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>${errorReportes}</div>
    </c:if>

    <!-- ============ REPORTE 1: INNER JOIN 4 tablas ============ -->
    <div class="card report-card mb-4">
        <div class="card-header">
            <i class="bi bi-diagram-3 me-2"></i>Propiedades con su tipo, ciudad e inmobiliaria
            <span class="badge bg-light text-dark ms-2">INNER JOIN (4 tablas)</span>
        </div>
        <div class="card-body">
            <details class="mb-3">
                <summary class="text-muted small">Ver consulta SQL</summary>
                <div class="report-sql mt-2">SELECT p.id_propiedad, p.titulo, p.precio, t.nombre, c.nombre, u.correo
FROM propiedad p
INNER JOIN tipo_propiedad t ON p.id_tipo = t.id_tipo
INNER JOIN ciudad c        ON p.id_ciudad = c.id_ciudad
INNER JOIN usuario u       ON p.id_inmobiliaria = u.id_usuario
WHERE p.estado_logico = TRUE
ORDER BY p.fecha_publicacion DESC;</div>
            </details>

            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>#</th><th>Titulo</th><th>Tipo</th><th>Ciudad</th><th>Inmobiliaria</th>
                            <th class="text-end">Precio</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty propiedadesConInmobiliaria}">
                                <tr><td colspan="6" class="text-center py-4 text-muted">Sin propiedades registradas.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${propiedadesConInmobiliaria}">
                                    <tr>
                                        <td>${r.idPropiedad}</td>
                                        <td>${r.titulo}</td>
                                        <td><span class="badge text-bg-light border">${r.nombreTipo}</span></td>
                                        <td>${r.nombreCiudad}</td>
                                        <td>${r.correoInmobiliaria}</td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${r.precio}" type="currency"
                                                              currencySymbol="$" maxFractionDigits="0"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
            <p class="text-muted small mt-2 mb-0">Total: ${fn:length(propiedadesConInmobiliaria)} propiedad(es).</p>
        </div>
    </div>

    <!-- ============ REPORTE 2: LEFT JOIN ============ -->
    <div class="card report-card mb-4">
        <div class="card-header">
            <i class="bi bi-image me-2"></i>Propiedades sin imagenes en su galeria
            <span class="badge bg-light text-dark ms-2">LEFT JOIN</span>
        </div>
        <div class="card-body">
            <details class="mb-3">
                <summary class="text-muted small">Ver consulta SQL</summary>
                <div class="report-sql mt-2">SELECT p.id_propiedad, p.matricula_inmobiliaria, p.titulo, t.nombre, c.nombre
FROM propiedad p
INNER JOIN tipo_propiedad t ON p.id_tipo = t.id_tipo
INNER JOIN ciudad c        ON p.id_ciudad = c.id_ciudad
LEFT JOIN imagen_propiedad i ON p.id_propiedad = i.id_propiedad
WHERE i.id_imagen IS NULL AND p.estado_logico = TRUE
ORDER BY p.fecha_publicacion DESC;</div>
            </details>

            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>#</th><th>Matricula</th><th>Titulo</th><th>Tipo</th><th>Ciudad</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty propiedadesSinImagenes}">
                                <tr><td colspan="5" class="text-center py-4 text-muted">
                                    Todas las propiedades tienen al menos una imagen.
                                </td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="p" items="${propiedadesSinImagenes}">
                                    <tr>
                                        <td>${p.idPropiedad}</td>
                                        <td class="fw-semibold">${p.matriculaInmobiliaria}</td>
                                        <td>${p.titulo}</td>
                                        <td><span class="badge text-bg-light border">${p.nombreTipo}</span></td>
                                        <td>${p.nombreCiudad}</td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
            <p class="text-muted small mt-2 mb-0">Total: ${fn:length(propiedadesSinImagenes)} propiedad(es) sin imagenes.</p>
        </div>
    </div>

    <!-- ============ REPORTE 3: GROUP BY + HAVING ============ -->
    <div class="card report-card mb-4">
        <div class="card-header">
            <i class="bi bi-pie-chart me-2"></i>Ciudades con 2 o mas propiedades activas
            <span class="badge bg-light text-dark ms-2">GROUP BY + HAVING</span>
        </div>
        <div class="card-body">
            <details class="mb-3">
                <summary class="text-muted small">Ver consulta SQL</summary>
                <div class="report-sql mt-2">SELECT c.nombre AS nombre_ciudad, COUNT(p.id_propiedad) AS total
FROM ciudad c
INNER JOIN propiedad p ON c.id_ciudad = p.id_ciudad
WHERE p.estado_logico = TRUE
GROUP BY c.id_ciudad, c.nombre
HAVING COUNT(p.id_propiedad) >= 2
ORDER BY total DESC, c.nombre ASC;</div>
            </details>

            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr><th>Ciudad</th><th class="text-center">Propiedades activas</th></tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty conteoPorCiudad}">
                                <tr><td colspan="2" class="text-center py-4 text-muted">
                                    Ninguna ciudad alcanza 2 o mas propiedades activas.
                                </td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="cc" items="${conteoPorCiudad}">
                                    <tr>
                                        <td>${cc.nombreCiudad}</td>
                                        <td class="text-center">
                                            <span class="badge text-bg-primary">${cc.total}</span>
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
