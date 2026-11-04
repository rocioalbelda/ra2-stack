# Seguridad del gestor

| Comprobación | Antes | Después |
|---|---|---|
| Cabecera Server | Expuesta (versión) | Oculta / Genérica |
| /xmlrpc.php | Accesible (200) | Bloqueado (403) |
| /wp-config.php | Accesible / Visible | Bloqueado (403) |
| PHP en uploads | Ejecutable (devuelve 2) | Bloqueado (403) |
| Edición de ficheros desde el panel | Permitida | Desactivada |
| Límite de intentos de login | Sin control | Protegido con plugin |

## Medidas aplicadas y por qué
- **Nginx:** Se deshabilitó la versión del servidor (server_tokens off) y se bloquearon los accesos directos a ficheros sensibles (xmlrpc.php, wp-config.php) y la ejecución de ficheros .php en la carpeta de subidas.
- **WordPress:** Se inhabilitó el editor interno mediante DISALLOW_FILE_EDIT y se protegió la plataforma frente a ataques de fuerza bruta.
