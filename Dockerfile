FROM richarvey/nginx-php-fpm:latest

COPY . .

# Variables d'environnement
ENV SKIP_COMPOSER 1
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1

ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr
ENV COMPOSER_ALLOW_SUPERUSER 1

# Installer SQLite système (nécessaire pour pdo_sqlite)
RUN apk add --no-cache sqlite sqlite-dev

# Installer l'extension PHP pdo_sqlite
RUN docker-php-ext-install pdo_sqlite

# Installer les dépendances Composer
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Créer le fichier SQLite
RUN touch /var/www/html/database/database.sqlite && chmod 666 /var/www/html/database/database.sqlite

# Permissions pour storage et cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

CMD ["/start.sh"]