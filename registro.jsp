<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="tituloPagina" value="Registro - Inmobiliaria UTS" scope="request"/>

<%@ include file="/includes/header.jsp"%>

    <style>
        body { min-height: 100vh; display: flex; align-items: center; justify-content: center;
               background: linear-gradient(135deg, #0B2545, #13315C, #134074); padding: 2rem 0; }
        .auth-card { background: #fff; border-radius: var(--radius-lg); box-shadow: var(--shadow-lg);
                     overflow: hidden; max-width: 960px; width: 100%; }
        .auth-left { background: linear-gradient(135deg, #0B2545, #134074); padding: 3rem;
                     display: flex; flex-direction: column; justify-content: center; align-items: center;
                     text-align: center; color: #fff; min-height: 500px; }
        .auth-left i { font-size: 4rem; color: var(--gold); margin-bottom: 1.5rem; }
        .auth-left h3 { font-family: 'Playfair Display', serif; font-weight: 700; margin-bottom: 1rem; }
        .auth-left p { color: rgba(255,255,255,0.7); max-width: 280px; line-height: 1.7; }
        .auth-right { padding: 2.5rem 3rem; }
        .auth-right h2 { font-family: 'Playfair Display', serif; font-weight: 700; color: #0B2545; margin-bottom: 0.5rem; }
        .auth-right .text-muted-custom { color: #6c757d; margin-bottom: 1.5rem; }
        .form-floating > .form-control { border: 2px solid #e9ecef; border-radius: var(--radius-sm); padding: 1rem; height: auto; }
        .form-floating > .form-control:focus { border-color: var(--gold); box-shadow: 0 0 0 3px rgba(184, 134, 11, 0.15); }
        .btn-auth { padding: 0.75rem 2rem; font-weight: 600; font-size: 1rem; border-radius: var(--radius-sm); width: 100%; }
        .auth-links { text-align: center; margin-top: 1.5rem; }
        .auth-links a { color: var(--gold); font-weight: 500; text-decoration: none; }
        .auth-links a:hover { text-decoration: underline; }
    </style>

    <div class="container" style="padding-top: 100px; padding-bottom: 3rem;">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="auth-card">
                    <div class="row g-0">
                        <!-- Panel izquierdo informativo -->
                        <div class="col-md-5">
                            <div class="auth-left">
                                <i class="bi bi-person-plus"></i>
                                <h3>Crea tu cuenta</h3>
                                <p>Registrate para acceder a las mejores opciones inmobiliarias de la region.</p>
                                <a href="${pageContext.request.contextPath}/index" class="btn btn-outline-light mt-3" style="border-radius: 50px; padding: 0.5rem 1.5rem;">
                                    <i class="bi bi-arrow-left me-1"></i> Volver al inicio
                                </a>
                            </div>
                        </div>

                        <!-- Formulario de registro -->
                        <div class="col-md-7">
                            <div class="auth-right">
                                <h2>Crear Cuenta</h2>
                                <p class="text-muted-custom">Completa tus datos para registrarte en el sistema</p>

                                <!-- Alerta de error -->
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger d-flex align-items-center alert-dismissible fade show" role="alert">
                                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                        <span>${error}</span>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
                                    </div>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/RegistroServlet" method="post" novalidate>
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <div class="form-floating mb-3">
                                                <input type="text" class="form-control" id="nombres" name="nombres"
                                                       placeholder="Nombres" value="${nombres}" required>
                                                <label for="nombres"><i class="bi bi-person me-1"></i> Nombres</label>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-floating mb-3">
                                                <input type="text" class="form-control" id="apellidos" name="apellidos"
                                                       placeholder="Apellidos" value="${apellidos}" required>
                                                <label for="apellidos"><i class="bi bi-person me-1"></i> Apellidos</label>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-floating mb-3">
                                        <input type="email" class="form-control" id="correo" name="correo"
                                               placeholder="correo@ejemplo.com" value="${correo}" required>
                                        <label for="correo"><i class="bi bi-envelope me-1"></i> Correo electronico</label>
                                    </div>

                                    <div class="form-floating mb-3">
                                        <input type="text" class="form-control" id="documento" name="documento"
                                               placeholder="Numero de documento" value="${documento}" required>
                                        <label for="documento"><i class="bi bi-card-heading me-1"></i> Numero de documento</label>
                                    </div>

                                    <div class="form-floating mb-4">
                                        <input type="password" class="form-control" id="password" name="password"
                                               placeholder="Minimo 6 caracteres" required minlength="6">
                                        <label for="password"><i class="bi bi-lock me-1"></i> Contrasena (min. 6 caracteres)</label>
                                    </div>

                                    <button type="submit" class="btn btn-gold btn-auth">
                                        <i class="bi bi-person-plus me-2"></i> Registrarse
                                    </button>
                                </form>

                                <div class="auth-links">
                                    <p class="mb-0">Ya tienes una cuenta?
                                        <a href="${pageContext.request.contextPath}/LoginServlet">Inicia sesion aqui</a>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

<%@ include file="/includes/footer.jsp"%>
