AUTHOR=henry4k
NAME=crossbuild
VERSION=latest
TAG=$(AUTHOR)/$(NAME):$(VERSION)

.PHONY: all
all: .image_id

.image_id: Dockerfile $(shell find assets)
	docker build --tag $(TAG) --iidfile $@ .

.PHONY: test
test: .image_id
	docker run --rm -it -v $(shell pwd)/test:/test -e CROSS_TRIPLE=x86_64-w64-mingw32 `cat $<` bash

.PHONY: push
push:
	docker push $(TAG)

.PHONY: clean
clean:
	rm -f .image_id

# docker rmi `cat .image_id`
