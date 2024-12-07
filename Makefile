all: build tag-push docker-push

build:
	$(eval VERSION=$(shell cat Version))
	docker build -t asolopovas/php-fpm:$(VERSION) .

tag-push:
	$(eval VERSION=$(shell cat Version))
	if git show-ref --tags | grep -q "$(VERSION)$$"; then git tag -d $(VERSION) && git push origin :refs/tags/$(VERSION); fi
	git tag $(VERSION)
	git push origin $(VERSION)
	if git rev-parse latest >/dev/null 2>&1; then git tag -d latest; fi
	git tag latest
	git push origin latest --force

docker-push:
	$(eval VERSION=$(shell cat Version))
	docker push asolopovas/php-fpm:$(VERSION)
	docker tag asolopovas/php-fpm:$(VERSION) asolopovas/php-fpm:latest
	docker push asolopovas/php-fpm:latest

clean:
	$(eval VERSION=$(shell cat Version))
	docker rmi asolopovas/php-fpm:$(VERSION)
