
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
- Configuración adicional: skip_mail: on para evitar errores de envío sin servidor SMTP local y registrar los envíos en Fflamingo.
- Verificación: envío de prueba como visitante y comprobación del mensaje y el campo ciclo en *Fflamingo -> Mensajes entrantes*.

### R2 — Aviso de cookies (LSSI y RGPD)
- Instalado y activado desde el panel de administración, configurado en español con botones *Aceptar* y *Rechazar* con el mismo peso visual y enlace a la política de cookies.
- Verificado en ventana privada: el aviso aparece al entrar y deja de mostrarse tras aceptar.

### R3 — Registro de actividad de usuarios
- Plugin instalado y activado mediante WP-CLI: simple-history.
- Visible en *Escritorio -> Historial*; comprobado el registro de inicio de sesión fallido y correcto con alumna.fct.

