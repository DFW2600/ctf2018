#!/usr/bin/make -k-
################################################################################
VIRTUAL_HOST	:= xmas2018.testnet.dapla.net
PORT		:= 8043
################################################################################
STACK		:= $(shell basename "$$(pwd)")

define DOCKERFILE
FROM node:latest AS BUILD
ADD ./src/frontend /src
WORKDIR .
RUN npm install && npm run test

FROM pierrezemb/gostatic:latest
COPY --from BUILD /src /svc/http
EXPOSE $(PORT)
endef
export DOCKERFILE

define DOCKER_COMPOSE
---
version: '3.6'
services:
  xmas:
    image: "$(STACK):latest"
    ports:
      - "$(PORT)/tcp"
    deploy:
      labels:
        traefik.port: 8043
        traefik.network: "public"
        traefik.enabled: 'true'
        traefik.frontend.priority: "10"
        traefik.frontend.rules: 'Host: $(VIRTUAL_HOST)'
      replicas: 1
      restart_policy:
        condition: on-failure
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

.DEFAULT: all
.PHONY: all clean image network display

all: deploy test

test:
	@curl -SsILk -XHEAD $(VIRTUAL_HOST)

clean:
	@docker stack rm $(STACK)

distclean: clean
	@-docker image rm $(STACK):latest
	@-docker volume ls | awk '/$(STACK)/ { system("docker volume rm "$2) }'
	@-rm Dockerfile docker-compose.yml

network:
	@-docker network create -d overlay --scope swarm $(NETWORK)

image:
	@echo "$$DOCKERFILE" | docker image build -t $(STACK):latest -

deploy: image
	@echo "$$DOCKER_COMPOSE" | docker stack deploy -c $< $(STACK) -

#===============================================================================

docker-compose.yml:
	@echo "$$DOCKER_COMPOSE" > $@

Dockerfile:
	@echo "$$DOCKERFILE" > $@
