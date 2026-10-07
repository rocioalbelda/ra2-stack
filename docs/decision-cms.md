# Sesión 9: Elección de imagen y versión del CMS

## Paso 1: Requisitos oficiales de WordPress
* **PHP:** Versión mínima recomendada PHP 7.4 o superior (idealmente PHP 8.2 u 8.3).
* **Base de datos:** MySQL 8.0+ o MariaDB 10.5+.
* **HTTPS:** Sí, se exige/recomienda servidor con HTTPS.

## Paso 2: Preguntas sobre la imagen en Docker Hub
* **Diferencia entre -apache y -fpm:** La versión -apache incluye el servidor web y PHP en el mismo contenedor. La versión -fpm contiene solo el motor de PHP, siendo más ligera pero obligando a usar un servidor web externo (como Nginx) para funcionar.
* **Significado de php8.3:** Especifica la versión exacta del intérprete de PHP instalada dentro de la imagen.
* **Por qué no conviene usar latest:** Porque la etiqueta latest cambia automáticamente con cada actualización; si se usa, impide mantener un entorno reproducible, pudiendo actualizar la versión de PHP o WordPress sin previo aviso.

## Decisión tomada
Usaremos la imagen wordpress:7.1-php8.3-fpm.
