<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:if test="${empty sessionScope.idUsuario}">
    <c:redirect url="${pageContext.request.contextPath}/LoginServlet"/>
</c:if>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Propiedades - Inmobiliaria UTS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
    <style>
        .dashboard-nav { background: #0B2545; padding: 0.75rem 0; }
        .page-header { padding: 2.5rem 0 1.5rem; }
        .table-card { border: none; border-radius: var(--radius-md); box-shadow: var(--shadow-sm); }
        .table thead th { background: #0B2545; color: #fff; font-weight: 600; white-space: nowrap; }
        .badge-tipo { background: rgba(184,134,11,0.15); color: var(--gold-dark); font-weight: 600; }
    </style>
</head>
<body style="background:#F8F9FA;">

    <nav class="dashboard-nav">
        <div class="container d-flex justify-content-between align-items-center">
            <a href="${pageContext.request.contextPath}/dashboard/agente/index.jsp"
               class="text-white fw-bold text-decoration-none" style="font-family:'Playfair Display',serif;">
                <i class="bi bi-buildings-fill me-2" style="color:var(--gold);"></i>
                Inmobiliaria <span style="color:var(--gold);">UTS</span>
                <span class="badge bg-primary ms-2">INMOBILIARIA</span>
            </a>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline-light btn-sm">
                <i class="bi bi-box-arrow-right me-1"></i> Cerrar Sesion
            </a>
        </div>
    </nav>

    <div class="container page-header">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <h2 class="mb-1" style="color:#0B2545;">
                    <i class="bi bi-house-door-fill me-2" style="color:var(--gold);"></i>Mis Propiedades
                </h2>
                <p class="text-muted mb-0">Gestiona tu catalogo de inmuebles activos.</p>
            </div>
            <a href="${pageContext.request.contextPath}/PropiedadServlet?action=new" class="btn btn-gold">
                <i class="bi bi-plus-circle me-1"></i> Nueva Propiedad
            </a>
        </div>
    </div>

    <div class="container pb-5">

        <!-- Alertas de exito / error -->
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
                                <th>Matricula</th>
                                <th>Titulo</th>
                                <th>Tipo</th>
                                <th>Ciudad</th>
                                <th class="text-end">Precio</th>
                                <th class="text-center">Hab.</th>
                                <th class="text-center">Banos</th>
                                <th class="text-center">Area m2</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty propiedades}">
                                    <tr>
                                        <td colspan="9" class="text-center py-5 text-muted">
                                            <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                            No tienes propiedades activas. Comienza creando una.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="p" items="${propiedades}">
                                        <tr>
                                            <td class="fw-semibold">${p.matriculaInmobiliaria}</td>
                                            <td>${p.titulo}</td>
                                            <td><span class="badge badge-tipo">${p.nombreTipo}</span></td>
                                            <td>${p.nombreCiudad}</td>
                                            <td class="text-end">
                                                <fmt:formatNumber value="${p.precio}" type="currency"
                                                                  currencySymbol="$" maxFractionDigits="0"/>
                                            </td>
                                            <td class="text-center">${p.habitaciones}</td>
                                            <td class="text-center">${p.banos}</td>
                                            <td class="text-center">${p.areaM2}</td>
                                            <td class="text-center" style="white-space:nowrap;">
                                                <a href="${pageContext.request.contextPath}/PropiedadServlet?action=edit&id=${p.idPropiedad}"
                                                   class="btn btn-sm btn-outline-primary" title="Editar">
                                                    <i class="bi bi-pencil-square"></i>
                                                </a>
                                                <button type="button" class="btn btn-sm btn-outline-danger"
                                                        title="Desactivar (baja logica)"
                                                        data-bs-toggle="modal" data-bs-target="#modalBaja"
                                                        data-id="${p.idPropiedad}"
                                                        data-titulo="${p.titulo}">
                                                    <i class="bi bi-trash3"></i>
                                                </button>
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
            <a href="${pageContext.request.contextPath}/dashboard/agente/index.jsp" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left me-1"></i> Volver al panel
            </a>
        </div>
    </div>

    <!-- Modal de confirmacion de baja logica -->
    <div class="modal fade" id="modalBaja" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-exclamation-triangle-fill text-danger me-2"></i>Confirmar desactivacion
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    Se aplicara <strong>baja logica</strong> a la propiedad
                    <strong id="nombrePropiedad"></strong>. El registro no se eliminara
                    de la base de datos, solo quedara inactivo.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <a href="#" id="btnConfirmarBaja" class="btn btn-danger">
                        <i class="bi bi-trash3 me-1"></i> Desactivar
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var modalBaja = document.getElementById('modalBaja');
        modalBaja.addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
            var id = button.getAttribute('data-id');
            var titulo = button.getAttribute('data-titulo');
            document.getElementById('nombrePropiedad').textContent = titulo;
            document.getElementById('btnConfirmarBaja').href =
                '${pageContext.request.contextPath}/PropiedadServlet?action=delete&id=' + id;
        });
    </script>
</body>
</html>
