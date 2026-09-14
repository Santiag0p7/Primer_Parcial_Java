<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="tituloPagina" value="Catalogo de Propiedades - JSGE In-Mobiliaria" scope="request"/>

<%@ include file="/includes/header.jsp"%>

    <section class="section-padding" style="padding-top:120px; background:#F8F9FA;">
        <div class="container">
            <div class="text-center mb-4">
                <span class="section-badge">Catalogo</span>
                <h2 class="section-title">Explora nuestras <span class="text-gold">Propiedades</span></h2>
                <p class="section-subtitle">Filtra por ciudad, tipo, precio y palabra clave.</p>
            </div>

            <!-- Panel de filtros -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/buscar" method="get" class="row g-3 align-items-end">
                        <div class="col-lg-3 col-md-6">
                            <label class="form-label search-label"><i class="bi bi-geo-alt me-1"></i> Ciudad</label>
                            <select name="idCiudad" class="form-select search-select">
                                <option value="">Todas las ciudades</option>
                                <c:forEach var="ci" items="${ciudades}">
                                    <option value="${ci.key}" ${filtroCiudad == ci.key ? 'selected' : ''}>${ci.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <label class="form-label search-label"><i class="bi bi-house-door me-1"></i> Tipo</label>
                            <select name="idTipo" class="form-select search-select">
                                <option value="">Todos los tipos</option>
                                <c:forEach var="ti" items="${tipos}">
                                    <option value="${ti.key}" ${filtroTipo == ti.key ? 'selected' : ''}>${ti.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-lg-2 col-md-6">
                            <label class="form-label search-label"><i class="bi bi-cash-stack me-1"></i> Precio min</label>
                            <input type="number" name="precio_min" class="form-control search-select" min="0" step="1000"
                                   placeholder="0" value="${filtroPrecioMin}">
                        </div>
                        <div class="col-lg-2 col-md-6">
                            <label class="form-label search-label"><i class="bi bi-cash-stack me-1"></i> Precio max</label>
                            <input type="number" name="precio_max" class="form-control search-select" min="0" step="1000"
                                   placeholder="Sin limite" value="${filtroPrecioMax}">
                        </div>
                        <div class="col-lg-2 col-md-12">
                            <label class="form-label search-label"><i class="bi bi-search me-1"></i> Palabra clave</label>
                            <input type="text" name="q" class="form-control search-select"
                                   placeholder="Ej: casa, balcon..." value="${filtroPalabra}">
                        </div>
                        <div class="col-12 d-flex gap-2">
                            <button type="submit" class="btn btn-gold">
                                <i class="bi bi-search me-1"></i> Buscar
                            </button>
                            <a href="${pageContext.request.contextPath}/buscar" class="btn btn-outline-secondary">
                                <i class="bi bi-x-circle me-1"></i> Limpiar filtros
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <c:if test="${not empty errorCatalogo}">
                <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>${errorCatalogo}</div>
            </c:if>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <p class="text-muted mb-0">
                    <i class="bi bi-collection me-1"></i>
                    <strong>${fn:length(propiedades)}</strong> propiedades encontradas
                    <c:if test="${hayFiltros}"><span class="badge bg-secondary ms-1">con filtros</span></c:if>
                </p>
            </div>

            <div class="row g-4">
                <c:choose>
                    <c:when test="${empty propiedades}">
                        <div class="col-12">
                            <div class="card border-0 shadow-sm">
                                <div class="card-body text-center py-5 text-muted">
                                    <i class="bi bi-search fs-1 d-block mb-2"></i>
                                    No se encontraron propiedades con los criterios seleccionados.
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="p" items="${propiedades}">
                            <div class="col-lg-4 col-md-6">
                                <div class="property-card">
                                    <div class="property-image">
                                        <c:choose>
                                            <c:when test="${not empty imagenesPrincipales[p.idPropiedad]}">
                                                <img src="${imagenesPrincipales[p.idPropiedad]}"
                                                     alt="${p.titulo}"
                                                     style="width:100%; height:220px; object-fit:cover;"
                                                     onerror="this.style.display='none'">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="property-img-placeholder">
                                                    <i class="bi bi-house-door"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="property-badge badge-venta">${p.nombreTipo}</span>
                                    </div>
                                    <div class="property-body">
                                        <div class="property-price">
                                            <fmt:formatNumber value="${p.precio}" type="currency"
                                                              currencySymbol="$" maxFractionDigits="0"/>
                                        </div>
                                        <h5 class="property-title">${p.titulo}</h5>
                                        <p class="property-location">
                                            <i class="bi bi-geo-alt me-1"></i> ${p.nombreCiudad}
                                        </p>
                                        <div class="property-features">
                                            <span><i class="bi bi-door-open me-1"></i> ${p.habitaciones} Hab.</span>
                                            <span><i class="bi bi-droplet me-1"></i> ${p.banos} Banos</span>
                                            <span><i class="bi bi-aspect-ratio me-1"></i> ${p.areaM2} m&sup2;</span>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/propiedad?id=${p.idPropiedad}"
                                           class="btn btn-gold-outline w-100 mt-3">
                                            <i class="bi bi-eye me-2"></i> Ver Detalle
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </section>

<%@ include file="/includes/footer.jsp"%>
