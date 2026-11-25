#!/usr/bin/env bash
# =====================================================================
# informe-accesos.sh — Informe de accesos a partir del log de nginx (RA3 · sesión 20)
#
# 1. Resumen en la terminal con herramientas básicas (awk, sort, uniq).
# 2. Informe HTML con GoAccess en informes/accesos_AAAAMMDD-HHMM.html
#
# Uso:  ./scripts/informe-accesos.sh
# =====================================================================
set -euo pipefail
cd "$(dirname "$0")/.."

LOG="logs/access.log"
[ -s "$LOG" ] || { echo "ERROR: $LOG no existe o está vacío. ¿Has montado ./logs en el servicio nginx?" >&2; exit 1; }
mkdir -p informes

echo "== Resumen de $LOG =="
echo "Peticiones totales:      $(wc -l < "$LOG")"
echo "Direcciones IP distintas: $(awk '{print $1}' "$LOG" | sort -u | wc -l)"
echo
echo "-- Códigos de respuesta --"
awk '{print $9}' "$LOG" | sort | uniq -c | sort -rn
echo
echo "-- 10 URL más pedidas --"
awk '{print $7}' "$LOG" | sort | uniq -c | sort -rn | head -10
echo
echo "-- Intentos de acceso al panel (POST /wp-login.php) --"
grep -c 'POST /wp-login.php' "$LOG" || true
echo
echo "-- IP con más intentos de acceso --"
grep 'POST /wp-login.php' "$LOG" | awk '{print $1}' | sort | uniq -c | sort -rn | head -5 || true

SALIDA="informes/accesos_$(date +%Y%m%d-%H%M).html"
echo
echo "-> Generando informe HTML con GoAccess..."
docker run --rm \
  -v "$PWD/logs:/logs:ro" \
  -v "$PWD/informes:/informes" \
  allinurl/goaccess /logs/access.log --log-format=COMBINED -o "/informes/$(basename "$SALIDA")"
echo "OK. Abre $SALIDA en el navegador."
