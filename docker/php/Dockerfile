# ==============================================================================
# ETAPA 1: Build (Compilación de Extensiones y Dependencias Composer)
# ==============================================================================
FROM php:8.3-fpm-bookworm AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev libxslt1-dev \
    libicu-dev libzip-dev libonig-dev libxml2-dev libssl-dev git unzip \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    bcmath gd intl soap sockets xsl zip pdo_mysql opcache ftp

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copiar manifiestos primero para cachear capas de Docker
COPY src/composer.json src/composer.lock* ./
RUN mkdir -p app/etc var generated pub/static pub/media

# Instalar dependencias
RUN composer install --no-dev --no-interaction --no-autoloader --no-scripts

# Copiar el código fuente completo
COPY src/ .

# Usar env.php mínimo sin Redis/DB para que setup:di:compile pueda correr sin servicios externos
COPY docker/php/build-env.php app/etc/env.php
RUN php -d memory_limit=-1 bin/magento setup:di:compile

# Restaurar env.php real en modo production y generar classmap con el código compilado
COPY src/app/etc/env.php app/etc/env.php
RUN sed -i "s/'MAGE_MODE' => 'developer'/'MAGE_MODE' => 'production'/" app/etc/env.php
RUN composer dump-autoload --optimize --no-dev --classmap-authoritative

# ==============================================================================
# ETAPA 2: Producción (Imagen Final Segura para GKE)
# ==============================================================================
FROM php:8.3-fpm-bookworm

WORKDIR /var/www/html

# Instalar NGINX y dependencias de ejecución
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx libjpeg62-turbo libpng16-16 libxslt1.1 libicu72 libzip4 libxml2 libssl3 libfreetype6 libonig5 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY --from=builder /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d

# Configurar usuario magento
RUN groupadd -g 1000 magento && useradd -u 1000 -g magento -m magento

# Copiar código final con permisos correctos para producción
COPY --from=builder --chown=magento:magento /var/www/html /var/www/html

# Configurar NGINX para que corra SIN ROOT (Puerto 8080 y directorios temporales)
COPY docker/php/default.conf /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default \
    && chown -R magento:magento /var/lib/nginx /var/log/nginx /etc/nginx \
    && touch /var/run/nginx.pid && chown magento:magento /var/run/nginx.pid

# Script de arranque múltiple adaptado para Kubernetes
RUN printf '#!/bin/sh\n\
php-fpm -D\n\
nginx -g "daemon off;"\n' > /usr/local/bin/start-services.sh \
    && chmod +x /usr/local/bin/start-services.sh \
    && chown magento:magento /usr/local/bin/start-services.sh

# Puerto de escucha libre de privilegios root
EXPOSE 8080

# CAMBIO CRÍTICO PARA GKE: Ejecución 100% segura sin privilegios de administrador
USER magento
CMD ["/usr/local/bin/start-services.sh"]
