# UTS Inmobiliaria

Sistema web de administración inmobiliaria desarrollado en **Java EE** bajo arquitectura **MVC** (Servlets + JSP + JDBC), como proyecto del primer parcial de la asignatura de Programación Web / Java. Permite gestionar propiedades, su galería de imágenes, características, solicitudes de visita/citas, usuarios, parámetros del sistema y reportes, con control de acceso por roles.

---

## Tabla de contenido

- [Descripción general](#descripción-general)
- [Stack tecnológico](#stack-tecnológico)
- [Arquitectura y roles](#arquitectura-y-roles)
- [Requisitos](#requisitos)
- [Instalación y ejecución local](#instalación-y-ejecución-local)
- [Base de datos](#base-de-datos)
- [Credenciales de prueba](#credenciales-de-prueba)
- [Configuración de la conexión JDBC](#configuración-de-la-conexión-jdbc)
- [Metodología Scrum](#metodología-scrum)
- [Estructura del proyecto](#estructura-del-proyecto)
- [Seguridad implementada](#seguridad-implementada)

---

## Descripción general

**UTS Inmobiliaria** es una aplicación web que implementa el núcleo de un negocio inmobiliario:

- Catálogo público de propiedades con buscador y filtros (ciudad, tipo, precio y palabra clave).
- Ficha de detalle con galería de imágenes (1:N) y características (N:M).
- Gestión de propiedades por parte de la inmobiliaria (CRUD, baja lógica y matrícula única).
- Agendamiento y gestión de solicitudes de visita/citas.
- Panel de administración global (usuarios, roles y tablas paramétricas).
- Reportes y métricas del sistema (INNER JOIN, LEFT JOIN, GROUP BY/HAVING, COUNT).
- Navegación dinámica por rol y perfil de usuario (1:1).

---

## Stack tecnológico

| Componente | Tecnología |
|------------|------------|
| Lenguaje | Java (JDK 8+ / probado con JDK 17) |
| Web | Java EE: Servlet API, JSP, JSTL 1.2 |
| Patrón | MVC (Modelo - Vista - Controlador) + DAO |
| Acceso a datos | JDBC con `PreparedStatement` |
| Base de datos | MySQL / MariaDB |
| Servidor | Apache Tomcat 8.5+ |
| Cifrado | jBCrypt 0.4 (hash BCrypt, 10 rondas) |
| Front-end | Bootstrap 5.3, Bootstrap Icons, CSS propio |
| Driver JDBC | MySQL Connector/J 8.4.0 |

Dependencias incluidas en `WEB-INF/lib/`:

- `mysql-connector-j-8.4.0.jar`
- `jstl-1.2.jar`
- `jbcrypt-0.4.jar`

---

## Arquitectura y roles

El proyecto sigue el patrón **MVC** con una capa **DAO** para el acceso a datos:

```
Navegador  ->  Servlet (Controlador)  ->  DAO  ->  Base de datos
                    |
                    v
                 JSP (Vista)
```

Roles del sistema:

| Rol | Descripción |
|-----|-------------|
| `ADMINISTRADOR` | Gestiona usuarios/roles, parámetros y consulta reportes. |
| `INMOBILIARIA` | Publica y administra propiedades, atiende solicitudes de visita. |
| `CLIENTE` | Explora el catálogo, agenda visitas y administra su perfil. |

El acceso se valida con un **filtro de servlet** (`AuthFilter`) que restringe `/dashboard/admin/*`, `/dashboard/agente/*` y `/dashboard/cliente/*` según el rol de la sesión.

---

## Requisitos

- **JDK 8 o superior** (probado con JDK 17).
- **Apache Tomcat 8.5 o superior** (probado con Tomcat 8.5.96 de XAMPP).
- **MySQL 5.7+ / MariaDB 10.4+** (probado con MariaDB 10.4 de XAMPP) en `localhost:3306`.
- Cliente de base de datos (phpMyAdmin, MySQL Workbench, DBeaver o consola `mysql`).
- Los JAR de `WEB-INF/lib/` ya están versionados en el repositorio.

---

## Instalación y ejecución local

### 1. Ubicar el proyecto

Coloca la carpeta del proyecto dentro de los despliegues de Tomcat:

```
<TOMCAT_HOME>/webapps/Primer_Parcial_Java/
```

### 2. Crear la base de datos

Importa el script consolidado (crea la base de datos, las tablas y los datos de prueba):

```bash
mysql -u root -p < db/proyecto_completo.sql
```

O desde phpMyAdmin: **Importar → seleccionar `db/proyecto_completo.sql` → Continuar**.

> El script es idempotente: elimina y recrea las tablas existentes.

### 3. Compilar las clases Java

El proyecto no usa Maven/Gradle; compila las fuentes a `WEB-INF/classes`.

**Windows (PowerShell):**

```powershell
$cp = "C:\xampp\tomcat\lib\servlet-api.jar;" + ((Get-ChildItem "WEB-INF\lib\*.jar").FullName -join ";")
$files = (Get-ChildItem -Recurse src -Filter *.java).FullName
javac -encoding UTF-8 -cp $cp -d WEB-INF\classes $files
```

**Linux / macOS:**

```bash
CP="$TOMCAT_HOME/lib/servlet-api.jar:$(find WEB-INF/lib -name '*.jar' | tr '\n' ':')"
javac -encoding UTF-8 -cp "$CP" -d WEB-INF/classes $(find src -name '*.java')
```

También puedes importar el proyecto en un IDE (Eclipse, IntelliJ IDEA o NetBeans) y compilarlo con el servidor Tomcat configurado.

### 4. Iniciar Tomcat y abrir la aplicación

Inicia el servidor y abre en el navegador:

```
http://localhost:8080/Primer_Parcial_Java/
```

La página de inicio es la landing page pública; desde ahí puedes registrarte o iniciar sesión.

---

## Base de datos

| Script | Contenido |
|--------|-----------|
| `db/proyecto_completo.sql` | **Consolidado final**: DDL + DML completo (recomendado). |
| `db/sprint1.sql` | Roles, usuarios, perfiles y autenticación. |
| `db/sprint2.sql` | Propiedades, imágenes, características y catálogos. |
| `db/sprint3.sql` | Solicitudes de visita/citas. |
| `db/sprint3_item2.sql` | Departamento en ciudades (parámetros). |
| `db/datos_demo_reportes.sql` | Datos de demostración para reportes. |

Modelo de datos principal:

- `usuario`, `rol`, `usuario_rol` (N:M), `perfil` (1:1)
- `propiedad`, `tipo_propiedad`, `ciudad`
- `imagen_propiedad` (1:N), `caracteristica`, `propiedad_caracteristica` (N:M)
- `solicitud_visita`

---

## Credenciales de prueba

| Rol | Correo | Contraseña |
|-----|--------|------------|
| ADMINISTRADOR | `admin@inmobiliaria.com` | `admin123` |
| INMOBILIARIA (Agente) | `inmo@inmobiliaria.com` | `inmo123` |
| CLIENTE | `cliente@inmobiliaria.com` | `cliente123` |

> Las contraseñas se almacenan **cifradas con BCrypt**; las anteriores son las credenciales en texto plano para iniciar sesión.

---

## Configuración de la conexión JDBC

Toda la configuración vive en **un único archivo** ubicado en la **raíz del proyecto**: `conexion.jspf`. Lo leen tanto la capa Java (`com.inmobiliaria.util.ConexionDB` / DAOs, vía `AppConfigListener`) como los JSP (con `<%@ include file="/conexion.jspf" %>`). Para pasar de una base de datos **local** a una **en línea** solo editas este archivo, sin recompilar ni tocar el resto del código.

```jsp
<%-- conexion.jspf (raíz del proyecto) --%>
// ----- LOCAL (XAMPP por defecto) -----
String DB_HOST    = "localhost";
int    DB_PORT    = 3306;
String DB_NOMBRE  = "inmobiliaria";
String DB_USUARIO = "root";
String DB_PASS    = "";
```

Ejemplo para **base de datos en línea** (comenta las de arriba y descomenta estas):

```jsp
String DB_HOST    = "miservidor.database.com";
int    DB_PORT    = 3306;
String DB_NOMBRE  = "inmobiliaria";
String DB_USUARIO = "usuario_remoto";
String DB_PASS    = "tu_password_seguro";
```

`AppConfigListener` lee `conexion.jspf` al arrancar Tomcat, extrae las variables y las expone a `ConexionDB`. Si el archivo no existe o falla, la app usa valores por defecto / variables de entorno sin romperse.

Además, cada parámetro puede sobreescribirse sin editar el archivo, en este orden de prioridad:

1. `conexion.jspf` (recomendado)
2. Propiedad del sistema JVM (`-Ddb.host=...`)
3. Variable de entorno (`DB_HOST`)
4. Valor por defecto (XAMPP)

| Parámetro | Variable en `conexion.jspf` | Variable de entorno | Valor por defecto |
|-----------|-----------------------------|---------------------|-------------------|
| Host | `DB_HOST` | `DB_HOST` | `localhost` |
| Puerto | `DB_PORT` | `DB_PORT` | `3306` |
| Base de datos | `DB_NOMBRE` | `DB_NAME` | `inmobiliaria` |
| Usuario | `DB_USUARIO` | `DB_USER` | `root` |
| Contraseña | `DB_PASS` | `DB_PASSWORD` | *(vacío)* |

---

## Metodología Scrum

El desarrollo se organizó en **3 Sprints** con tablero Kanban y documentación en `docs/`.

| Sprint | Objetivo | Estado |
|--------|----------|--------|
| **Sprint 1** | Cimientos y acceso: landing, registro, login, BCrypt y control de acceso por roles. | ✅ Completado |
| **Sprint 2** | Núcleo del negocio: CRUD de propiedades, baja lógica, galería 1:N, características N:M, buscador, ficha de detalle y perfil 1:1. | ✅ Completado |
| **Sprint 3** | Interacción y administración: citas/solicitudes, gestión de usuarios y parámetros, reportes/métricas y consolidado SQL. | ✅ Completado |

Documentación de cada sprint:

- `docs/sprint1_planning.md`
- `docs/sprint2_planning.md`
- `docs/sprint3_planning.md`

---

## Estructura del proyecto

```
Primer_Parcial_Java/
├── src/main/java/com/inmobiliaria/
│   ├── controller/     # Servlets (controladores MVC)
│   ├── dao/            # Acceso a datos (JDBC + PreparedStatement)
│   ├── model/          # POJOs / entidades
│   ├── filter/         # AuthFilter (seguridad por rol)
│   └── util/           # ConexionDB (configurable)
├── dashboard/
│   ├── admin/          # Panel de administración (usuarios, parámetros, reportes)
│   ├── agente/         # Panel de la inmobiliaria (propiedades, galería, solicitudes)
│   ├── cliente/        # Panel del cliente (citas)
│   └── mi_perfil.jsp
├── includes/           # header.jsp, footer.jsp
├── db/                 # Scripts SQL (proyecto_completo.sql + por sprint)
├── docs/               # Planificación Scrum y evidencias
├── assets/             # CSS, JS e imágenes
├── conexion.jspf       # ÚNICA configuración de conexión (local / en línea)
├── WEB-INF/
│   ├── web.xml         # Mapeo de servlets, filtros y listener
│   ├── classes/        # Clases compiladas (no versionadas)
│   └── lib/            # Dependencias JAR
├── catalogo.jsp
├── detalle_propiedad.jsp
├── index.jsp
├── login.jsp
├── registro.jsp
└── README.md
```

---

## Seguridad implementada

- **Contraseñas cifradas** con BCrypt (nunca en texto plano) — `RegistroServlet` / `LoginServlet`.
- **Prevención de SQL Injection**: uso exclusivo de `PreparedStatement` en todos los DAOs.
- **Control de acceso por rol**: `AuthFilter` + validación de sesión en cada servlet sensible.
- **Cuentas activas/bloqueadas**: el login rechaza usuarios con `estado = FALSE`.
- **Configuración externa**: credenciales de BD fuera del código, vía propiedades o variables de entorno.
- **Auto-protección del administrador**: no puede cambiar su propio rol ni bloquear su cuenta.

---

## Autor

Proyecto académico — **UTS Inmobiliaria**.
Desarrollado por Jhoan Santiago Garcia Estupiñan.
