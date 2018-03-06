          ROOT_PATH = .
       PROJECT_NAME = jupyter
         IMAGE_NAME = my$(PROJECT_NAME)
       BUILD_SERVER = teramine.com
        PUSH_TARGET = aurora@$(BUILD_SERVER):server/docker/$(PROJECT_NAME)/src
              SHELL = /bin/bash

all:

push-snapshot:
	rsync --exclude=err --delete -avz $(ROOT_PATH) $(PUSH_TARGET)

build: dclean
	docker build --rm=true --force-rm=true -t $(IMAGE_NAME):latest .

run:
	-docker run --rm=true -p 80:80 -p 443:443 -v ~/server/docker/jupyter/src/notebooks:/home/aurora/notebooks $(IMAGE_NAME):latest

stop:
	if [[ $$(docker ps -f "ancestor=$(IMAGE_NAME)" -q | wc -l) -gt 0 ]]; then docker stop $$(docker ps -f "ancestor=$(IMAGE_NAME)" -q); fi

rm: stop
	docker rm $$(docker ps -f ancestor=$(IMAGE_NAME) -a -q)

dclean:
	if [[ $$(docker images -f "dangling=true" -q | wc -l) -gt 0 ]]; then docker rmi $$(docker images -f "dangling=true" -q); fi

realclean:
	-docker rmi $(IMAGE_NAME):latest
	-docker rmi ubuntu:16.04

clean:
	find . -name '*~' -exec rm {} \;
