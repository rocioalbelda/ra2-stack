# Sesión 9: Elección de imagen y versión del CMS

Los Requisitos oficiales de WordPress son:

- PHP: Versión recomendada PHP 7.4 o superior (idealmente PHP 8.2 u 8.3).
- Base de datos: MySQL 8.0 o superior O MariaDB 10.5 o superior.
- HTTPS: Sí, exige o recomienda soporte HTTPS.

¿Qué diferencia hay entre -apache y -fpm?
La etiqueta apache incluye el servidor web y PHP en el mismo contenedor por eso funciona sola. Y la versión fpm contiene solo el motor PHP, siendo más ligera pero obligando a usar un servidor web externo.

¿Qué significa php8.3?
Especifica la versión del intérprete de PHP instalada dentro de la imagen del contenedor.

¿Por qué no conviene usar latest?
Porque la etiqueta latest cambia automáticamente con cada actualización. Si se usa, impide mantener un entorno reproducible, pudiendo actualizar la versión de PHP o WordPress sin previo aviso y romper la aplicación.

Decisión tomada:
Usaremos la imagen wordpress:7.1-php8.3-fpm.
