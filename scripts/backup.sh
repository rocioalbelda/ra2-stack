#!/usr/bin/env bash
# =====================================================================
# backup.sh — Copia de seguridad del WordPress del stack (RA3 · práctica 2)
#
# Guarda en backups/ dos ficheros con la misma marca de fecha:
#   db_AAAAMMDD-HHMMSS.sql.gz          -> volcado de la base de datos
#   wp-content_AAAAMMDD-HHMMSS.tar.gz  -> temas, plugins y medios subidos
# y conserva solo las últimas $CONSERVAR copias.
#
# Uso (desde cualquier carpeta del repositorio):  ./scripts/backup.sh
# =====================================================================
set -euo pipefail

cd "$(dirname "$0")/.."

DESTINO="backups"
CONSERVAR=7
FECHA="$(date +%Y%m%d-%H%M%S)"
F_DB="$DESTINO/db_$FECHA.sql.gz"
F_WP="$DESTINO/wp-content_$FECHA.tar.gz"

trap 'echo "ERROR: la copia no se ha completado." >&2; rm -f "$F_DB" "$F_WP"' ERR

mkdir -p "$DESTINO"
echo "== Copia de seguridad $FECHA =="

for servicio in db wordpress; do
  if ! docker compose ps --status running --services 2>/dev/null | tr -d '\r' | grep -qx "$servicio"; then
    echo "ERROR: el servicio '$servicio' no está en marcha. Ejecuta: docker compose up -d" >&2
    exit 1
  fi
done

echo "-> Volcando la base de datos..."
docker compose exec -T db sh -c '
  : "${WP_DB_USER:?falta WP_DB_USER en .env}" "${WP_DB_NAME:?falta WP_DB_NAME en .env}"
  exec mariadb-dump --single-transaction --no-tablespaces \
       -u"$WP_DB_USER" -p"$WP_DB_PASSWORD" "$WP_DB_NAME"' \
  | gzip > "$F_DB"

echo "-> Empaquetando wp-content..."
MSYS_NO_PATHCONV=1 docker compose exec -T wordpress tar -czf - -C /var/www/html wp-content > "$F_WP"

gzip -t "$F_DB" "$F_WP"
[ "$(gunzip -c "$F_DB" | grep -c 'CREATE TABLE')" -gt 0 ] || { echo "ERROR: el volcado no contiene tablas" >&2; exit 1; }

for patron in 'db_*.sql.gz' 'wp-content_*.tar.gz'; do
  # shellcheck disable=SC2012,SC2086
  ls -1t "$DESTINO"/$patron 2>/dev/null | tail -n +"$((CONSERVAR + 1))" | xargs -r rm -f --
done

echo "OK. Copia guardada:"
ls -lh "$F_DB" "$F_WP"
echo "Copias disponibles: $(ls -1 "$DESTINO"/db_*.sql.gz | wc -l) (se conservan $CONSERVAR)"