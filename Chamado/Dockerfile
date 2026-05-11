# --- Estágio 1: Build do Frontend ---
FROM node:20-alpine AS frontend-builder

WORKDIR /app
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ .
RUN npm run build

# --- Estágio 2: PHP & Nginx ---
FROM serversideup/php:8.2-fpm-nginx

# Configurações do PHP
ENV PHP_OPCACHE_ENABLE=1 \
    AUTORUN_ENABLED=true

# Copia o código do backend
WORKDIR /var/www/html
COPY --chown=www-data:www-data backend/ .

# Copia os assets compilados do estágio anterior
COPY --from=frontend-builder --chown=www-data:www-data /app/public/build ./public/build

# Instala dependências do Composer
RUN composer install --no-dev --optimize-autoloader

# Script de inicialização (customizado)
COPY --chown=www-data:www-data scripts/deploy.sh /var/www/html/scripts/deploy.sh
RUN chmod +x /var/www/html/scripts/deploy.sh

# Render espera que a porta seja configurada via variável de ambiente PORT
# O serversideup já lida com isso por padrão se usarmos o entrypoint correto
