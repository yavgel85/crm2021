.DEFAULT_GOAL := help

help:
	@echo "Welcome to IT Support! Have you tried terning it off and on again?"

install:
	@composer install

test:
	docker exec crm2021_php php artisan test

migrate:
	docker exec crm2021_php php artisan migrate

analyse:
	./vendor/bin/phpstan analyse

generate:
	docker exec crm2021_php php artisan ide-helper:models --write

nginx:
	docker exec -it crm2021_nginx /bin/sh

php:
	docker exec -it crm2021_php /bin/sh

mysql:
	docker exec -it crm2021_mysql /bin/sh

redis:
	docker exec -it crm2021_redis /bin/sh

# Error starting userland proxy: listen tcp4 0.0.0.0:443: bind: address already in use
# Error starting userland proxy: listen tcp4 0.0.0.0:80: bind: address already in use
# https://github.com/nginx-proxy/nginx-proxy/issues/839
# sudo apachectl stop
stop-apache2:
	sudo systemctl stop apache2 && echo manual | sudo tee /etc/init/apache2.override
