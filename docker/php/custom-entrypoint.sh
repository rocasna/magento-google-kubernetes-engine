#!/bin/bash
set -e

# Asegurar permisos en carpetas clave
chmod -R 775 var generated pub/static pub/media

# Esperar a que la base de datos esté lista (opcional pero recomendado)
# bin/magento setup:install ... (solo si no hay env.php)

exec "$@"