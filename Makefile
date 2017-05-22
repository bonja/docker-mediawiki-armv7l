
IMAGE_NAME='mediawiki-armv7l'
CONTAINER_NAME='mediawiki'

CONTAINER_ID=$(shell sudo docker container list -f name=$(CONTAINER_NAME) -q -a)
CONTAINER_PS=$(shell sudo docker ps -f name=$(CONTAINER_NAME) -q)

build:
	sudo docker build -t $(IMAGE_NAME) .

start:
ifneq ("$(CONTAINER_PS)","")
	$(info Stop : $(shell sudo docker stop $(CONTAINER_PS)))
endif
ifneq ("$(CONTAINER_ID)","")
	$(info Remove : $(shell sudo docker rm $(CONTAINER_ID)))
endif
	$(info Start : $(shell sudo docker run --name $(CONTAINER_NAME) -p 80:80 --link mysql -d $(IMAGE_NAME)))

stop:
ifneq ("$(CONTAINER_PS)","")
	$(info Stop : $(shell sudo docker stop $(CONTAINER_PS)))
endif
ifneq ("$(CONTAINER_ID)","")
	$(info Remove : $(shell sudo docker rm $(CONTAINER_ID)))
endif

