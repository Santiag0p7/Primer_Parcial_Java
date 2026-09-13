<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/includes/header.jsp"%>

    <!-- Hero Banner con Buscador -->
    <section id="inicio" class="hero-section">
        <div class="hero-overlay"></div>
        <div class="hero-content">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-10 text-center">
                        <span class="hero-badge">La mejor experiencia inmobiliaria</span>
                        <h1 class="hero-title">
                            Encuentra tu <span class="text-gold">Hogar Ideal</span><br>en Santander
                        </h1>
                        <p class="hero-subtitle">
                            Asesoria personalizada en compra, venta y arriendo de propiedades
                            en Bucaramanga y la region metropolitana.
                        </p>
                    </div>
                </div>

                <!-- Buscador Rapido -->
                <div class="row justify-content-center mt-4">
                    <div class="col-lg-11">
                        <div class="search-box">
                            <form action="${pageContext.request.contextPath}/buscar" method="get" class="search-form">
                                <div class="row g-3 align-items-end">
                                    <div class="col-lg-3 col-md-6">
                                        <label class="form-label search-label">
                                            <i class="bi bi-house-door me-1"></i> Tipo de Inmueble
                                        </label>
                                        <select name="idTipo" class="form-select search-select">
                                            <option value="" selected>Todos los tipos</option>
                                            <c:forEach var="ti" items="${tipos}">
                                                <option value="${ti.key}">${ti.value}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-lg-3 col-md-6">
                                        <label class="form-label search-label">
                                            <i class="bi bi-geo-alt me-1"></i> Ciudad
                                        </label>
                                        <select name="idCiudad" class="form-select search-select">
                                            <option value="" selected>Todas las ciudades</option>
                                            <c:forEach var="ci" items="${ciudades}">
                                                <option value="${ci.key}">${ci.value}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-lg-3 col-md-6">
                                        <label class="form-label search-label">
                                            <i class="bi bi-search me-1"></i> Palabra clave
                                        </label>
                                        <input type="text" name="q" class="form-control search-select"
                                               placeholder="Ej: casa, balcon, piscina...">
                                    </div>
                                    <div class="col-lg-3 col-md-6">
                                        <button type="submit" class="btn btn-gold btn-search w-100">
                                            <i class="bi bi-search me-2"></i> Buscar Propiedad
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Estadisticas -->
                <div class="row justify-content-center mt-5">
                    <div class="col-lg-10">
                        <div class="row g-4 text-center hero-stats">
                            <div class="col-md-3 col-6">
                                <div class="stat-item">
                                    <span class="stat-number" data-target="250">0</span>+
                                    <p class="stat-label">Propiedades</p>
                                </div>
                            </div>
                            <div class="col-md-3 col-6">
                                <div class="stat-item">
                                    <span class="stat-number" data-target="180">0</span>+
                                    <p class="stat-label">Clientes Felices</p>
                                </div>
                            </div>
                            <div class="col-md-3 col-6">
                                <div class="stat-item">
                                    <span class="stat-number" data-target="10">0</span>+
                                    <p class="stat-label">Anos de Experiencia</p>
                                </div>
                            </div>
                            <div class="col-md-3 col-6">
                                <div class="stat-item">
                                    <span class="stat-number" data-target="15">0</span>+
                                    <p class="stat-label">Asesores Expertos</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Seccion Nosotros -->
    <section id="nosotros" class="section-padding bg-light">
        <div class="container">
            <div class="row align-items-center g-5">
                <div class="col-lg-6">
                    <span class="section-badge">Sobre Nosotros</span>
                    <h2 class="section-title">
                        La mejor eleccion en <span class="text-gold">Bienes Raices</span>
                    </h2>
                    <p class="section-text">
                        En Inmobiliaria UTS nos dedicamos a hacer realidad el sueno de nuestros
                        clientes. Con mas de una decada de trayectoria en el mercado inmobiliario
                        santandereano, hemos construido una reputacion basada en la confianza,
                        la transparencia y la excelencia en el servicio.
                    </p>
                    <div class="row g-3 mt-4">
                        <div class="col-sm-6">
                            <div class="d-flex align-items-start">
                                <div class="about-icon">
                                    <i class="bi bi-shield-check"></i>
                                </div>
                                <div class="ms-3">
                                    <h6 class="fw-bold">Confianza</h6>
                                    <small class="text-muted">Operaciones 100% seguras y transparentes</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="d-flex align-items-start">
                                <div class="about-icon">
                                    <i class="bi bi-people"></i>
                                </div>
                                <div class="ms-3">
                                    <h6 class="fw-bold">Asesoria Personalizada</h6>
                                    <small class="text-muted">Equipo dedicado para cada cliente</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="d-flex align-items-start">
                                <div class="about-icon">
                                    <i class="bi bi-graph-up-arrow"></i>
                                </div>
                                <div class="ms-3">
                                    <h6 class="fw-bold">Experiencia</h6>
                                    <small class="text-muted">Mas de 10 anos en el mercado</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="d-flex align-items-start">
                                <div class="about-icon">
                                    <i class="bi bi-award"></i>
                                </div>
                                <div class="ms-3">
                                    <h6 class="fw-bold">Calidad</h6>
                                    <small class="text-muted">Propiedades verificadas y avaladas</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="about-image-wrapper">
                        <div class="about-image-card">
                            <div class="about-img-placeholder">
                                <i class="bi bi-buildings"></i>
                                <p>Oficinas Inmobiliaria UTS</p>
                            </div>
                        </div>
                        <div class="experience-badge">
                            <span class="exp-number">10+</span>
                            <span class="exp-text">Anos de<br>Experiencia</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Seccion Servicios -->
    <section id="servicios" class="section-padding">
        <div class="container">
            <div class="text-center mb-5">
                <span class="section-badge">Nuestros Servicios</span>
                <h2 class="section-title">
                    Soluciones <span class="text-gold">Inmobiliarias</span> Integrales
                </h2>
                <p class="section-subtitle">
                    Ofrecemos un portafolio completo de servicios disenados para
                    acompanarte en cada etapa de tu proceso inmobiliario.
                </p>
            </div>

            <div class="row g-4">
                <div class="col-lg-3 col-md-6">
                    <div class="service-card">
                        <div class="service-icon">
                            <i class="bi bi-chat-dots-fill"></i>
                        </div>
                        <h5 class="service-title">Asesoria Inmobiliaria</h5>
                        <p class="service-text">
                            Orientacion experta en compra, venta y arriendo de propiedades.
                            Analisis de mercado y estrategia personalizada para cada cliente.
                        </p>
                        <a href="#contacto" class="service-link">
                            Mas informacion <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="service-card">
                        <div class="service-icon">
                            <i class="bi bi-clipboard-check-fill"></i>
                        </div>
                        <h5 class="service-title">Avaluos Profesionales</h5>
                        <p class="service-text">
                            Determinacion objetiva del valor comercial de su inmueble
                            respaldada por normatividad nacional y experiencia del mercado local.
                        </p>
                        <a href="#contacto" class="service-link">
                            Mas informacion <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="service-card">
                        <div class="service-icon">
                            <i class="bi bi-file-earmark-text-fill"></i>
                        </div>
                        <h5 class="service-title">Gestion de Tramites</h5>
                        <p class="service-text">
                            Tramitacion integral de documentos legales, constitucion de
                            hipotecas, legalizacion de escrituras y mas.
                        </p>
                        <a href="#contacto" class="service-link">
                            Mas informacion <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <div class="service-card">
                        <div class="service-icon">
                            <i class="bi bi-calendar-check-fill"></i>
                        </div>
                        <h5 class="service-title">Agendamiento de Citas</h5>
                        <p class="service-text">
                            Coordina una visita a la propiedad de tu interes de forma
                            rapida y sencilla con nuestros asesores especializados.
                        </p>
                        <a href="#contacto" class="service-link">
                            Mas informacion <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Seccion Propiedades Destacadas -->
    <section id="propiedades" class="section-padding bg-light">
        <div class="container">
            <div class="text-center mb-5">
                <span class="section-badge">Catalogo</span>
                <h2 class="section-title">
                    Propiedades <span class="text-gold">Destacadas</span>
                </h2>
                <p class="section-subtitle">
                    Descubre nuestra seleccion de las mejores propiedades disponibles
                    en Bucaramanga y la region metropolitana.
                </p>
            </div>

            <div class="row g-4">
                <c:choose>
                    <c:when test="${empty propiedadesDestacadas}">
                        <div class="col-12">
                            <div class="card border-0 shadow-sm">
                                <div class="card-body text-center py-5 text-muted">
                                    <i class="bi bi-house-door fs-1 d-block mb-2"></i>
                                    Aun no hay propiedades publicadas. Vuelve pronto.
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="p" items="${propiedadesDestacadas}">
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
                                            <i class="bi bi-geo-alt me-1"></i> ${p.nombreCiudad}, Santander
                                        </p>
                                        <div class="property-features">
                                            <span><i class="bi bi-door-open me-1"></i> ${p.habitaciones} Habitaciones</span>
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

                <div class="col-12 text-center mt-4">
                    <a href="${pageContext.request.contextPath}/buscar" class="btn btn-gold btn-lg px-5">
                        <i class="bi bi-collection me-2"></i> Ver todo el catalogo
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Seccion CTA -->
    <section class="cta-section">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8 text-center">
                    <h2 class="cta-title">¿Listo para encontrar tu proximo hogar?</h2>
                    <p class="cta-text">
                        Unete a los cientos de familias que ya confian en nosotros.
                        Registrate ahora y accede a las mejores opciones del mercado.
                    </p>
                    <div class="d-flex gap-3 justify-content-center flex-wrap">
                        <a href="${pageContext.request.contextPath}/RegistroServlet" class="btn btn-gold btn-lg px-5">
                            <i class="bi bi-person-plus me-2"></i> Registrarse Gratis
                        </a>
                        <a href="${pageContext.request.contextPath}/LoginServlet" class="btn btn-outline-light btn-lg px-5">
                            <i class="bi bi-box-arrow-in-right me-2"></i> Iniciar Sesion
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

<%@ include file="/includes/footer.jsp"%>
