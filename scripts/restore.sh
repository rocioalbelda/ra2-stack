#!/usr/bin/env bash
# =====================================================================
# restore.sh — Restaura una copia hecha con backup.sh (RA3 · sesión 16)
#
# Uso:  ./scripts/restore.sh                    -> lista las copias disponibles
#       ./scripts/restore.sh 20261104-121500    -> restaura esa copia
# =====================================================================
set -euo pipefail
cd "$(dirname "$0")/.."

FECHA="${1:-}"
if [ -z "$FECHA" ]; then
  echo "Uso: $0 FECHA"
  echo "Copias disponibles:"
  ls -1 backups/db_*.sql.gz 2>/dev/null | sed 's#backups/db_##; s#\.sql\.gz##' || echo "  (ninguna)"
  exit 1
fi

F_DB="backups/db_$FECHA.sql.gz"
F_WP="backups/wp-content_$FECHA.tar.gz"
for f in "$F_DB" "$F_WP"; do
  [ -f "$f" ] || { echo "ERROR: no existe $f" >&2; exit 1; }
done
gzip -t "$F_DB" "$F_WP"

echo "Se va a SOBRESCRIBIR la base de datos y wp-content con la copia $FECHA."
read -r -p "Escribe SI (en mayúsculas) para continuar: " respuesta
[ "$respuesta" = "SI" ] || { echo "Cancelado."; exit 1; }

echo "-> Restaurando la base de datos..."
gunzip -c "$F_DB" | docker compose exec -T db sh -c \
  'exec mariadb -u"$WP_DB_USER" -p"$WP_DB_PASSWORD" "$WP_DB_NAME"'

echo "-> Restaurando wp-content..."
docker compose exec -T wordpress rm -rf /var/www/html/wp-content
docker compose exec -T wordpress tar -xzf - -C /var/www/html < "$F_WP"
docker compose exec -T wordpress chown -R www-data:www-data /var/www/html/wp-content

echo "OK. Restaurada la copia $FECHA. Recarga el sitio en el navegador."
