all: build push

build:
	DOCKER_BUILDKIT=1 docker build -t runzhliu/yum-with-browser . --progress=plain

push:
	docker push runzhliu/yum-with-browser
