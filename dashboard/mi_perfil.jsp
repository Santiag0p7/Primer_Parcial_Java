<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${empty sessionScope.idUsuario}">
    <c:redirect url="${pageContext.request.contextPath}/LoginServlet"/>
</c:if>
<c:set var="tituloPagina" value="Mi Perfil - JSGE In-Mobiliaria" scope="request"/>
<%@ include file="/includes/header.jsp"%>

<style>
    .profile-card { border: none; border-radius: var(--radius-md); box-shadow: var(--shadow-sm); }
    .profile-avatar {
        width: 96px; height: 96px; border-radius: 50%;
        background: linear-gradient(135deg, var(--gold), var(--gold-light));
        color: #fff; display: flex; align-items: center; justify-content: center;
        font-size: 2.5rem; margin: 0 auto;
    }
    .form-label { font-weight: 600; color: #0B2545; }
    .form-control:read-only { background-color: #F1F3F5; }
</style>

    <div class="container" style="padding-top:120px; padding-bottom:2rem;">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <h2 class="mb-1" style="color:#0B2545;">
                    <i class="bi bi-person-circle me-2" style="color:var(--gold);"></i>Mi Perfil
                </h2>
                <p class="text-muted mb-0">Administra tu informacion personal y de contacto.</p>
            </div>
            <span class="badge bg-success">${sessionScope.rol}</span>
        </div>
    </div>

    <div class="container pb-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">

                <%-- Alertas de confirmacion / error --%>
                <c:if test="${not empty exito}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>${exito}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
                    </div>
                </c:if>

                <div class="card profile-card">
                    <div class="card-body p-4 p-md-5">

                        <div class="text-center mb-4">
                            <div class="profile-avatar mb-3">
                                <i class="bi bi-person-fill"></i>
                            </div>
                            <h4 class="mb-0" style="color:#0B2545;">
                                <c:out value="${perfil.nombres}"/> <c:out value="${perfil.apellidos}"/>
                            </h4>
                            <c:if test="${not empty perfil.fechaActualizacion}">
                                <small class="text-muted">
                                    Ultima actualizacion: <c:out value="${perfil.fechaActualizacion}"/>
                                </small>
                            </c:if>
                        </div>

                        <form action="${pageContext.request.contextPath}/PerfilServlet" method="post"
                              class="row g-3" novalidate>

                            <div class="col-12">
                                <label for="correo" class="form-label">
                                    <i class="bi bi-envelope-fill me-1" style="color:var(--gold);"></i>
                                    Correo electronico
                                </label>
                                <input type="email" class="form-control" id="correo"
                                       value="<c:out value='${sessionScope.correo}'/>"
                                       readonly disabled>
                                <div class="form-text">El correo pertenece a tu cuenta y no puede modificarse.</div>
                            </div>

                            <div class="col-md-6">
                                <label for="nombres" class="form-label">
                                    Nombres <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="nombres" name="nombres"
                                       maxlength="100" required
                                       value="<c:out value='${perfil.nombres}'/>">
                            </div>

                            <div class="col-md-6">
                                <label for="apellidos" class="form-label">
                                    Apellidos <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="apellidos" name="apellidos"
                                       maxlength="100" required
                                       value="<c:out value='${perfil.apellidos}'/>">
                            </div>

                            <div class="col-md-6">
                                <label for="documento" class="form-label">
                                    Documento de Identidad <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="documento" name="documento"
                                       maxlength="20" required
                                       value="<c:out value='${perfil.documento}'/>">
                            </div>

                            <div class="col-md-6">
                                <label for="telefono" class="form-label">Telefono de Contacto</label>
                                <input type="tel" class="form-control" id="telefono" name="telefono"
                                       maxlength="20"
                                       value="<c:out value='${perfil.telefono}'/>">
                            </div>

                            <div class="col-12">
                                <label for="direccion" class="form-label">Direccion</label>
                                <input type="text" class="form-control" id="direccion" name="direccion"
                                       maxlength="150"
                                       value="<c:out value='${perfil.direccion}'/>">
                            </div>

                            <div class="col-12 d-flex flex-wrap gap-2 pt-2">
                                <button type="submit" class="btn btn-gold">
                                    <i class="bi bi-save me-1"></i> Guardar cambios
                                </button>
                                <a href="${pageContext.request.contextPath}/index"
                                   class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-1"></i> Volver
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
