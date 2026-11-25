
## 2. Selección y comparativa de plugins (R1, R2 y R3)

### Plugins actuales en el entorno
- akismet (5.7.2): inactivo.
- hello (1.7.2): inactivo.
- limit-login-attempts-reloaded (3.4.4, actualización disponible 3.4.6): activo.

### Comparativa y elección por requisito
| Requisito | Candidato (slug) | Instalaciones activas | Valoración | Última actualización | Decisión |
| :--- | :--- | :---: | :---: | :---: | :--- |
| R1: Formulario + guardar mensajes | contact-form-7 (+ contact-form-cfdb7) | 10.000.000 (600.000 CFDB7) | 80 (100 CFDB7) | 2026-11-23 (2026-10-09) | Elegido: estándar muy usado y CFDB7 almacena los envíos en BD. |
| R1: Formulario + guardar mensajes | forminator | 600.000 | 96 | 2026-11-17 | Alternativa con formularios y registro de envíos integrado. |
| R2: Cookies (LSSI y RGPD) | cookie-law-info | 100.000.000+ | 96 | 2026-11-12 | Elegido: instalado desde el panel y configurado para LSSI/RGPD. |
| R2: Cookies (LSSI y RGPD) | cookie-notice | 800.000 | 96 | 2026-11-20 | Alternativa ligera y bien valorada para aviso de cookies. |
| R3: Registro de actividad | simple-history | activo (v5.36.0) | - | 2026-11 | Elegido: instalado por WP-CLI para auditoría de actividad. |
| R3: Registro de actividad | aryo-activity-log | 200.000 | 86 | 2026-11-22 | Alternativa sencilla de historial de cambios reciente. |

### Criterios de selección aplicados
- Instalaciones activas altas y valoración sólida.
- Última actualización reciente (todos actualizados en octubre o noviembre de 2026, sin abandono).
- Compatibilidad con la versión actual de WordPress y soporte activo.

## 3. Implantación de módulos (R1, R2 y R3)

### R1 — Formulario de contacto con guardado de mensajes
- Plugins instalados y activos: contact-form-7 y flamingo.
- Campo añadido en *Formulario de contacto 1*: desplegable ciclo con opciones ASIR, DAW y SMR.
- Configuración adicional: skip_mail: on para evitar errores de envío sin servidor SMTP local y registrar los envíos en flamingo.
- Verificación: envío de prueba como visitante y comprobación del mensaje y el campo ciclo en flamingo -> Mensajes entrantes.

### R2 — Aviso de cookies (LSSI y RGPD)
- Instalado y activado desde el panel de administración, configurado en español con botones *Aceptar* y *Rechazar* con el mismo peso visual y enlace a la política de cookies.
- Verificado en ventana privada: el aviso aparece al entrar y deja de mostrarse tras aceptar.

### R3 — Registro de actividad de usuarios
- Plugin instalado y activado mediante WP-CLI: simple-history.
- Visible en *Escritorio -> Historial*; comprobado el registro de inicio de sesión fallido y correcto con  alumna.fct.


---

# Práctica 2 · Copias de seguridad automatizadas (RA3 · CE d)

## 1. Qué hay que copiar
- **Base de datos (
a3-stack_db_data):** sí (volcado SQL con entradas, usuarios, ajustes, roles y plantillas editadas).
- **Ficheros del sitio (
a3-stack_wp_data):** sí (fichero .tar.gz con temas, plugins y archivos subidos).
- **Núcleo de WordPress (wp-admin, wp-includes) y wp-config.php:** no (provienen de la imagen y de la configuración del compose).
- **Repositorio (docker-compose.yml, 
ginx/, scripts/):** versionado en GitHub.
- **.env:** fuera de GitHub, custodiado aparte en el equipo.

## 2. Técnica general: copia de volumen con contenedor  lpine
- Volumen 
a3-stack_wp_data montado en modo solo lectura (:ro) hacia .\backups mediante un contenedor  lpine (
olumen_wp_data.tar.gz, ~47,7 MB / 50.018.087 bytes).

## 3. Volcado manual de base de datos
- Volcado comprimido con mariadb-dump --single-transaction --no-tablespaces usando las credenciales del usuario de WordPress ($WP_DB_USER, $WP_DB_PASSWORD, $WP_DB_NAME) y compresión gzip en backups/prueba.sql.gz (217.238 bytes).
- Verificada la integridad del archivo y el conteo de tablas: 17 sentencias CREATE TABLE.

## 4. Script automatizado scripts/backup.sh
- Script con set -euo pipefail, limpieza ante fallo (	rap ... ERR), comprobación de servicios db y wordpress, volcado de base de datos, empaquetado de wp-content, validación gzip -t + conteo de tablas y rotación conservando las últimas 7 copias.
- Ejecutado generando db_AAAAMMDD-HHMMSS.sql.gz y wp-content_AAAAMMDD-HHMMSS.tar.gz en backups/.

## 5. Prueba de restauración con scripts/restore.sh
- Realizada copia previa 20261124-150126 antes del desastre controlado.
- Eliminada permanentemente la entrada 47 (Novedades) y el plugin flamingo.
- Ejecutada la restauración de 20261124-150126 y verificado que vuelven tanto la entrada 47 como el plugin flamingo.

## 6. Automatización programada (cron)
- En equipos Linux del aula con cron activo, se añade con crontab -e (30 13 * * 2,3  cd /ruta/a/tu/repo && ./scripts/backup.sh >> bbackups/backup.log 2>&1) para ejecutar copias los martes y miércoles a las 13:30 y registrar la salida en backups/backup.log.
- En Windows con Docker Desktop se ejecuta ./scripts/backup.sh mediante Git Bash (y en Codespaces al cierre de sesión, descargando bbackups/ periódicamente).

# Práctica 3 · Importar y exportar contenidos en distintos formatos (RA3 · CE e)

## 1. Cuatro formatos y sus usos
- **WXR (XML)**: entradas, páginas, categorías, etiquetas, comentarios y autores para mover contenido entre sitios WordPress.
- **CSV**: formato tabular (una fila por registro) para hojas de cálculo e importación/exportación de usuarios o listados.
- **JSON (API REST)**: datos estructurados para integración con otras aplicaciones.
- **SQL**: base de datos completa para respaldos y migraciones íntegras.
- Creada la carpeta `exportaciones/` (ignorada en `.gitignore`).


## 2. Exportación del sitio en WXR
- Exportado el contenido del sitio a exportaciones/sitio_20261125.xml mediante ./wp export --stdout.
- Total de elementos <item>: 22 (7 ttachment, 6 page, 5 post, 1 wp_template_part, 1 wpcf7_contact_form, 1 wp_navigation, 1 wp_global_styles).

## 3. Importación de contenidos de ejemplo (contenidos_asir.xml)
- Activado wordpress-importer e importado /datos/contenidos_asir.xml con --authors=create.
- Importadas 6 entradas (#101–#106) en Noticias, Eventos y Prácticas, y 2 páginas (#107 *Horario del ciclo* y #108 *Normas del aula técnica*).

## 4. Importacion de usuarios desde CSV
- Revisada la cabecera y primeras filas de datos/usuarios.csv.
- Ejecutada la importacion con ./wp user import-csv /datos/usuarios.csv (creando usuarios nuevos y actualizando existentes sin contrasenas en texto plano).
- Comprobado el listado final de usuarios y roles con ./wp user list.

## 5. Exportacion de listados en CSV y JSON
- Exportadas las entradas a exportaciones/entradas.csv (ID,post_title,post_date,post_status) con --format=csv.
- Exportados los usuarios a exportaciones/usuarios.json (user_login,user_email,roles) con --format=json y validada su estructura JSON.

## 6. Consulta JSON desde la API REST de WordPress
- Consultadas las 3 ultimas entradas (/wp-json/wp/v2/posts?per_page=3&_fields=id,title,link) y los usuarios publicos (/wp-json/wp/v2/users?_fields=id,name) en formato JSON.

## 7. Exportacion SQL de wp_users y riesgo de seguridad
- Exportada la tabla wp_users a exportaciones/wp_users.sql mediante mariadb-dump en el servicio db.
- Comprobado que el volcado contiene los hashes de contrasena (p. ej., `$wp`$2y$...), expuestos a ataques de fuerza bruta si el fichero se filtra; por ello backups/ y exportaciones/ permanecen excluidos en .gitignore.

## 8. Intercambio cooperativo en formato WXR
- He creado una entrada de cinco lineas en la categoria Practicas explicando para que sirve cada formato.
- La he exportado desde Herramientas Exportar eligiendo entradas de la categoria Practicas y se la he pasado a mi pareja.
- Luego he importado el archivo XML de mi pareja desde Herramientas Importar y he comprobado que su entrada sale publicada con su usuario como autor.

