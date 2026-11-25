\# Stack WordPress con Nginx, PHP-FPM y MariaDB (RA2)



Despliegue contenedorizado de WordPress mediante Docker Compose compuesto por \*\*Nginx\*\* (`nginx:stable`), \*\*WordPress con PHP-FPM\*\* (`wordpress:php8.3-fpm`) y \*\*MariaDB\*\* (`mariadb:11`), con volúmenes persistentes para los archivos de la aplicación y la base de datos.



\## Requisitos

\- \*\*Docker\*\* y \*\*Docker Compose\*\* instalados y en ejecución.

\- \*\*Git\*\* para clonar y gestionar el repositorio.



\## Puesta en marcha desde cero

1\. Clonar el repositorio y entrar en el directorio del proyecto:

&#x20;  ```bash

&#x20;  git clone \[https://github.com/rocioalbelda/ra2-stack.git](https://github.com/rocioalbelda/ra2-stack.git)

&#x20;  cd ra2-stack

$readmeBackupSection = @"

## Copias de seguridad

### Realizar una copia automatizada
Con los servicios `db` y `wordpress` en marcha, ejecuta desde Git Bash en la raíz del repositorio:

```bash
./scripts/backup.sh

