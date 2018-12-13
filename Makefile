PYTHON = python3.6
ACTIVATE = . ./venv/bin/activate;
MODULE_NAME = foo

DEV_CONTAINER_IMAGE = pydev
DEV_CONTAINER_NAME = dev_container
MYSQL_CONTAINER_NAME = mysqld
REDIS_CONTAINER_NAME = redis

.PHONY: help
.DEFAULT_GOAL: help

help:
	@echo "These are public command list (\`・ω・´)"
	@grep -E '^[a-zA-Z_%-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean: clean_venv remove_compose ## Cleaning up your environment

setup: install install_dev ## Setup environment

test: lint test_docker ## Testing

# local venv (mainly for IDE)
clean_venv:
	rm -rf venv

venv:
	$(PYTHON) -m venv venv

install: venv
	$(ACTIVATE) pip install -r requirements.txt -c constraints.txt

install_dev: venv
	$(ACTIVATE) pip install -r requirements-dev.txt -c constraints.txt

freeze: venv  ## Freeze pip modules into constraints.txt
	$(ACTIVATE) pip freeze > constraints.txt

lint: venv
	$(ACTIVATE) flake8 foo
	$(ACTIVATE) mypy foo

# dev container
build_devcontainer:
	docker build -t $(DEV_CONTAINER_IMAGE) .

run_devcontainer: build_devcontainer ## Booting up dev container
	docker run --link $(MYSQL_CONTAINER_NAME) --link $(REDIS_CONTAINER_NAME) \
	--name  $(DEV_CONTAINER_NAME) -it --rm $(DEV_CONTAINER_IMAGE) ptpython

# docker compose
test_docker:
	docker-compose up --build --abort-on-container-exit

remove_compose:
	docker-compose rm -f
