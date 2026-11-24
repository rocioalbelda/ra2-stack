# Pruebas de funcionamiento y rendimiento

| Prueba | Resultado | ¿Correcto? |
|---|---|---|
| Servicios en marcha | `db` (`mariadb:11`), `wordpress` (`wordpress:php8.3-fpm`) y `nginx` (`nginx:stable`) en estado `Up` / `Running` (`docker compose ps`) | Sí |
| Sitio y panel | Carga correcta de `/` y acceso a `/wp-admin` con el tema aplicado | Sí |
| Subida de ficheros | Subida de imagen de varios MB completada sin error | Sí |
| Enlaces permanentes | Entrada abierta directamente por su URL sin error 404 | Sí |
| Persistencia (down/up) | Tras `docker compose down` y `docker compose up -d` (sin `-v`), contenidos y datos conservados en `wp_data` y `db_data` | Sí |
| Seguridad (403) | `curl.exe -I http://localhost:8080/xmlrpc.php` devuelve `403 Forbidden` | Sí |

## Rendimiento
- **Tiempos de respuesta en el aula (5 medidas):**
  1. `0,1605 s` (`160,55 ms`)
  2. `0,1363 s` (`136,34 ms`)
  3. `0,1244 s` (`124,42 ms`)
  4. `0,1315 s` (`131,49 ms`)
  5. `0,1266 s` (`126,57 ms`)
- **Memoria por contenedor (`docker stats --no-stream`):**
  - `ra2-stack-db-1` (MariaDB 11): `128,4 MiB` / `3,63 GiB` (`3,45 %`)
  - `ra2-stack-wordpress-1` (WordPress PHP 8.3 FPM): `60,83 MiB` / `3,63 GiB` (`1,64 %`)
  - `ra2-stack-nginx-1` (Nginx stable): `12,71 MiB` / `3,63 GiB` (`0,34 %`)
- **Interpretación:** La primera petición (`160,55 ms`) tarda algo más que las siguientes (`124,42 ms` – `136,34 ms`) debido a la inicialización y calentamiento de rutas y cachés en las peticiones posteriores. En cuanto al consumo de memoria, la base de datos (`db`) es el contenedor que más recursos utiliza (`128,4 MiB`) al gestionar los datos y buffers, seguido de `wordpress` (`60,83 MiB`) y `nginx` (`12,71 MiB`), que actúa como proxy inverso ligero.