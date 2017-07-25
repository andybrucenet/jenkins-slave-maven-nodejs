include SAMEERSBN_DOCKER_GITLAB_ENV.sh

.PHONY: all help build release push sameersbn-docker-gitlab
all: build

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make build        - build the lmgitlab image"

build:
	@docker build --tag=dockerregistry.hlsdev.local:5000/lmgitlab .

release: build
	@docker build --tag=dockerregistry.hlsdev.local:5000/lmgitlab:$(shell cat VERSION) .

push: release
	@docker push dockerregistry.hlsdev.local:5000/lmgitlab :latest
	@docker push dockerregistry.hlsdev.local:5000/lmgitlab:$(shell cat ./VERSION)

# unused target - kept it for historical reasons
sameersbn-docker-gitlab:
	@echo "SAMEERSBN_DOCKER_GITLAB_VERSION=$(SAMEERSBN_DOCKER_GITLAB_VERSION)"
	@if [ ! -d git/docker-gitlab ] ; then mkdir -p git ; cd ./git ; git clone $(SAMEERSBN_DOCKER_GITLAB_URI) ; cd $(SAMEERSBN_DOCKER_GITLAB_REPO) ; git fetch --all --tags --prune ; git checkout tags/$(SAMEERSBN_DOCKER_GITLAB_VERSION) ; else true ; fi
	@if ! docker images | grep --quiet -e '$(SAMEERSBN_DOCKER_GITLAB_FULLREPO)\s\+$(SAMEERSBN_DOCKER_GITLAB_VERSION)' ; then cd ./git/$(SAMEERSBN_DOCKER_GITLAB_REPO) ; make build ; else true ; fi

