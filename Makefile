#!make

MAKEFLAGS += --always-make
PARAM=$(filter-out $@,$(MAKECMDGOALS))

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

%:
	@:

_exec:
	docker run --rm -v $$(pwd):/project -w /project -it node:16-alpine sh -c "apk add -q make && $(PARAM)"

########################################################################################################################

owner: ## reset folder owner
	sudo chown --changes -R $$(whoami) ./
	@echo "Success"

dist: ## build static markup
	@rm -rf dist
	npm rebuild node-sass
	npm run d

node_modules: ## install node_modules
	@rm -rf node_modules
	npm install

docker-dist: ## build static markup
	@$(MAKE) _exec "make dist"
	@echo "Open file://$$(pwd)/dist/index.html"

docker-node_modules: ## install node_modules
	@$(MAKE) _exec "make node_modules"

docker:
	@$(MAKE) _exec sh
