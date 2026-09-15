#!/bin/sh
# ============================================================
# Arranque de Tomcat en Render.
# Render expone el puerto a traves de la variable de entorno PORT;
# Tomcat por defecto escucha en 8080. Aqui se sincroniza el puerto
# HTTP de server.xml con $PORT antes de iniciar el servidor.
# ============================================================
set -e

PORT="${PORT:-8080}"
sed -i "s/port=\"8080\"/port=\"${PORT}\"/g" /usr/local/tomcat/conf/server.xml

exec catalina.sh run
