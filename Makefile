#!/usr/bin/make
################################################################################
STACK		:= $(shell basename "$$(pwd)")
VIRTUAL_HOST	:= xmas2018.testnet.dapla.net

export STACK
################################################################################

define DOCKERFILE
FROM pierrezemb/gostatic:latest
EXPOSE 8043
ADD src/ /srv/http
endef
export DOCKERFILE


define DOCKER_COMPOSE
---
version: '3.6'
services:
  xmas:
    image: "${STACK}:latest"
    ports:
      - "8043/tcp"
    deploy:
      labels:
        traefik.network: "public"
        traefik.enabled: 'true'
        traefik.port: 8043
        traefik.frontend.rules: 'Host: $(VIRTUAL_HOST)'
      replicas: 1
    networks:
      - public
networks:
  public:
    external: true
    name: public
...
endef
export DOCKER_COMPOSE

#===============================================================================

.PHONEY: all clean image network display
.DEFAULT: all

all: clean image deploy

clean:
	@-docker stack rm $(STACK)
	@-docker image ls | awk '/$(STACK)/ { system("docker image rm "$1":latest") }'

distclean: clean
	@-docker volume ls | awk '/$(STACK)/ { system("docker volume rm "$2) }'
	@-rm Dockerfile docker-compose.yml

network:
	@-docker network create -d overlay --scope swarm $(NETWORK)

image: Dockerfile
	@docker build -t $(STACK):latest $(shell dirname $<)

deploy: docker-compose.yml
	@docker stack deploy -c $< $(STACK)

#===============================================================================

docker-compose.yml: export DOCKER_COMPOSE:=$(DOCKER_COMPOSE)
docker-compose.yml:
	@echo "$${DOCKER_COMPOSE}" > $@

Dockerfile: export DOCKERFILE:=$(DOCKERFILE)
Dockerfile:
	@echo "$${DOCKERFILE}" > $@
