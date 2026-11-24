#!/usr/bin/env bash
# =====================================================================
# backup.sh — Copia de seguridad del WordPress del stack (RA3 · sesión 16)
#
# Guarda en backups/ dos ficheros con la misma marca de fecha:
#   db_AAAAMMDD-HHMMSS.sql.gz          -> volcado de la base de datos
#   wp-content_AAAAMMDD-HHMMSS.tar.gz  -> temas, plugins y medios subidos
# y conserva solo las últimas $CONSERVAR copias.
#
# Uso (desde cualquier carpeta del repositorio):  ./scripts/backup.sh
# =====================================================================
set -euo pipefail                      # parar ante cualquier error, variable sin definir o fallo en una tubería

cd "$(dirname "$0")/.."                # ir a la raíz del repositorio (donde está docker-compose.yml)

DESTINO="backups"
CONSERVAR=7
FECHA="$(date +%Y%m%d-%H%M%S)"
F_DB="$DESTINO/db_$FECHA.sql.gz"
F_WP="$DESTINO/wp-content_$FECHA.tar.gz"

# Si algo falla a mitad, borrar los ficheros incompletos
trap 'echo "ERROR: la copia no se ha completado." >&2; rm -f "$F_DB" "$F_WP"' ERR

mkdir -p "$DESTINO"
echo "== Copia de seguridad $FECHA =="

# 0. Comprobar que los servicios necesarios están en marcha
for servicio in db wordpress; do
  if ! docker compose ps --status running --services | grep -qx "$servicio"; then
    echo "ERROR: el servicio '$servicio' no está en marcha. Ejecuta: docker compose up -d" >&2
    exit 1
  fi
done

# 1. Base de datos: mariadb-dump se ejecuta DENTRO del contenedor db.
#    Las comillas simples hacen que las variables se lean del entorno del contenedor
#    (las recibe del .env), así la contraseña no aparece en la línea de órdenes del equipo.
echo "-> Volcando la base de datos..."
docker compose exec -T db sh -c '
  : "${WP_DB_USER:?falta WP_DB_USER en .env}" "${WP_DB_NAME:?falta WP_DB_NAME en .env}"
  exec mariadb-dump --single-transaction --no-tablespaces \
       -u"$WP_DB_USER" -p"$WP_DB_PASSWORD" "$WP_DB_NAME"' \
  | gzip > "$F_DB"

# 2. Ficheros: solo wp-content. El núcleo de WordPress viene en la imagen
#    y wp-config.php se genera con las variables del compose.
echo "-> Empaquetando wp-content..."
docker compose exec -T wordpress tar -czf - -C /var/www/html wp-content > "$F_WP"

# 3. Verificar que los dos ficheros son gzip válidos y no están vacíos
gzip -t "$F_DB" "$F_WP"
[ "$(gunzip -c "$F_DB" | grep -c 'CREATE TABLE')" -gt 0 ] || { echo "ERROR: el volcado no contiene tablas" >&2; exit 1; }

# 4. Rotación: borrar las copias más antiguas y quedarse con las $CONSERVAR últimas
for patron in 'db_*.sql.gz' 'wp-content_*.tar.gz'; do
  # shellcheck disable=SC2012,SC2086  # nombres generados por este script, sin espacios
  ls -1t "$DESTINO"/$patron 2>/dev/null | tail -n +"$((CONSERVAR + 1))" | xargs -r rm -f --
done

echo "OK. Copia guardada:"
ls -lh "$F_DB" "$F_WP"
echo "Copias disponibles: $(ls -1 "$DESTINO"/db_*.sql.gz | wc -l) (se conservan $CONSERVAR)"
