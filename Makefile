
IMAGE_NAME=mediawiki-armv7l

CONTAINER_NAME=mediawiki
CONTAINER_ID=$(shell sudo docker container list -f name=$(CONTAINER_NAME) -q -a)
CONTAINER_PS=$(shell sudo docker ps -f name=$(CONTAINER_NAME) -q)

#VOLUME_NAME=mediawiki-data
#VOLUME_ID=$(shell sudo docker volume list -f name=$(VOLUME_NAME) -q)

build:
	sudo docker build -t $(IMAGE_NAME) .

start:
ifneq ("$(CONTAINER_PS)","")
	sudo docker stop $(CONTAINER_PS)
endif
ifneq ("$(CONTAINER_ID)","")
	sudo docker rm $(CONTAINER_ID)
endif
#ifeq ("$(VOLUME_ID)","")
#	sudo docker volume create --name $(VOLUME_NAME)
#endif
	sudo docker run --name $(CONTAINER_NAME) -v /home/darkgs/.local/mediawiki:/data -p 80:80 --link mysql -d $(IMAGE_NAME)

stop:
ifneq ("$(CONTAINER_PS)","")
	sudo docker stop $(CONTAINER_PS)
endif
ifneq ("$(CONTAINER_ID)","")
	sudo docker rm $(CONTAINER_ID)
endif

clean:
ifneq ("$(CONTAINER_PS)","")
	sudo docker stop $(CONTAINER_PS)
endif
ifneq ("$(CONTAINER_ID)","")
	sudo docker rm $(CONTAINER_ID)
endif

