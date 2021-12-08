# import config.
# You can change the default config with `make cnf="config_special.env" build`
cnf ?= .env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

NAME := $(PROJECT_NAME)

# This will output the help for each task
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

## Commands

install: ## Install dependencies
	@composer install

test: ## Run tests
	docker exec $(PROJECT_NAME)_php php artisan test

migrate: ## Run migrate
	docker exec $(PROJECT_NAME)_php php artisan migrate

analyse:  ## Run analyse php code
	./vendor/bin/phpstan analyse

generate: ## Generate IDE helper doc-blocks
	docker exec $(PROJECT_NAME)_php php artisan ide-helper:models --write

nginx: ## Run nginx
	docker exec -it $(PROJECT_NAME)_nginx /bin/sh

php: ## Run php
	docker exec -it $(PROJECT_NAME)_php /bin/sh

mysql: ## Run mysql
	docker exec -it $(PROJECT_NAME)_mysql /bin/sh

redis: ## Run redis
	docker exec -it $(PROJECT_NAME)_redis /bin/sh

#docker-clear:
#	docker container rm -f $(docker container ls -a -q) && docker image rm -f $(docker image ls -a -q)

docker-destroy: ## Destroy containers and images
	-$(call destroy_containers,$(NAME))
	-$(call destroy_images,$(NAME))

define destroy_containers
	docker container rm --force `docker container ls --all --quiet --filter name=$(1)` 2>/dev/null
endef

define destroy_images
	docker image rm --force `docker image ls --all --quiet $(1)` 2>/dev/null
endef

# Error starting userland proxy: listen tcp4 0.0.0.0:443: bind: address already in use
# Error starting userland proxy: listen tcp4 0.0.0.0:80: bind: address already in use
# https://github.com/nginx-proxy/nginx-proxy/issues/839
# sudo apachectl stop
stop-apache2:
	sudo systemctl stop apache2 && echo manual | sudo tee /etc/init/apache2.override
