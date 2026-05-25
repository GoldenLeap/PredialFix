#!/usr/bin/env bash

echo "🚀 Iniciando processo de deploy..."

# Rodar migrações
echo "Running migrations..."
php artisan migrate --force

# Otimizar o Laravel
echo "Optimizing Laravel..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "✅ Deploy concluído!"
