#!/usr/bin/make -k-
################################################################################
VIRTUAL_HOST	:= northpole.dallasmakerspace.org
PORT		:= 8043
VOLUME		:= /$(shell pwd)://src
NODE_VERSION	:= latest
NETWORK		:= public
IMAGE		:= dallasmakerspace/ctf2018:latest
################################################################################
STACK		:= $(shell basename "$$(pwd)")
npm		:= docker run -v $(VOLUME) -w //src -ti --rm node:$(NODE_VERSION) npm

define BUILD_DOCKERFILE
FROM node:latest AS builder
ADD ./src /src
WORKDIR /src
RUN npm install && npm run test

FROM pierrezemb/gostatic:latest
COPY --from=builder /src/frontend /svc/http
EXPOSE $(PORT)
endef

define DOCKERFILE
FROM pierrezemb/gostatic:latest
EXPOSE $(PORT)
ADD src/ /srv/http
endef
export DOCKERFILE

define DOCKER_COMPOSE
---
version: '3.6'
services:
  xmas:
    image: "$(IMAGE)"
    ports:
      - "$(PORT)/tcp"
    deploy:
      labels:
        orbiter.down: '3'
        orbiter.up: '6'
        orbiter: 'true'
        traefik.backend: 'northpole'
        traefik.default.protocol: 'http'
        traefik.enabled: 'true'
        traefik.frontend.entryPoints: 'http, https'
        traefik.frontend.priority: '10'
        traefik.frontend.rule: 'Host:$(VIRTUAL_HOST)'
        traefik.network: "$(NETWORK)"
        traefik.docker.network: '$(NETWORK)'
        traefik.port: 8043
      replicas: 3
      restart_policy:
        condition: on-failure
    networks:
      public: {}

networks:
  public:
    external: true
    name: $(NETWORK)
...
endef
export DOCKER_COMPOSE

#===============================================================================

.DEFAULT: all
.PHONY: all clean image network display depends

all: deploy test

dist: Dockerfile docker-compose.yml
	@git commit -am '(chore) latest automated release'

test:
	@curl -SsILk -XHEAD $(VIRTUAL_HOST)

clean:
	@docker stack rm $(STACK)

distclean: clean
	@-docker image rm $(STACK):latest
	@-docker volume ls | awk '/$(STACK)/ { system("docker volume rm "$$2) }'
	@-docker container prune -f
	@-docker volume prune -f
	@-docker image prune -f
	@-rm -f Dockerfile docker-compose.yml

deploy: depends
	@echo "$$DOCKER_COMPOSE" | docker stack deploy -c- $(STACK)

#depends: package.json network image
depends: network image
	#@$(call npm,install)

network:
	@-docker network create -d overlay --scope swarm $(NETWORK)

image: Dockerfile
	@docker image build -t $(STACK):latest .

#===============================================================================

docker-compose.yml:
	@echo "$$DOCKER_COMPOSE" > $@

Dockerfile:
	@echo "$$DOCKERFILE" > $@

package.json:
	@$(call npm) init
