# ============================================================
# Dockerfile - JSGE In-Mobiliaria (JSP / Servlets) para Render
# Imagen base: Tomcat 9 (Servlet 4.0) + JDK 17
# ============================================================
FROM tomcat:9.0-jdk17-temurin

# Elimina las aplicaciones por defecto para desplegar en la raiz (/)
RUN rm -rf /usr/local/tomcat/webapps/*

# El repositorio completo es la aplicacion web
WORKDIR /app
COPY . /app

# Compila las fuentes Java a WEB-INF/classes usando el servlet-api de Tomcat
RUN mkdir -p /app/WEB-INF/classes \
    && CP="/usr/local/tomcat/lib/servlet-api.jar:$(find /app/WEB-INF/lib -name '*.jar' | tr '\n' ':')" \
    && javac -encoding UTF-8 -cp "$CP" -d /app/WEB-INF/classes $(find /app/src -name '*.java')

# Copia la aplicacion al directorio de despliegue (ROOT) y limpia las fuentes
RUN cp -r /app/. /usr/local/tomcat/webapps/ROOT/ \
    && rm -rf /usr/local/tomcat/webapps/ROOT/src \
    && rm -rf /usr/local/tomcat/webapps/ROOT/Dockerfile \
    && rm -rf /usr/local/tomcat/webapps/ROOT/docker-entrypoint.sh

# Script de arranque: mapea el puerto que Render inyecta en $PORT
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
