AUTHOR=henry4k
NAME=crossbuild
VERSION=latest

.image_id: Dockerfile install-ninja.sh
	docker build --tag $(AUTHOR)/$(NAME):$(VERSION) --iidfile $@ .

.PHONY: push
push:
	docker push $(NAME):$(VERSION)

.PHONY: clean
clean:
	rm -f .image_id

# docker rmi `cat .image_id`
