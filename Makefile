.PHONY: all build release push

DOCKER_TAG = "andybrucenet/jenkins-slave-maven-nodejs"

all: build

build:
	@docker build --tag=$(DOCKER_TAG) .

release: build
	@docker build --tag=$(DOCKER_TAG):$(shell cat VERSION)  .

push: release
	@docker push $(DOCKER_TAG):latest
	@docker push $(DOCKER_TAG):$(shell cat ./VERSION)

