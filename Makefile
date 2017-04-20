PYTHON = python3.6
ACTIVATE = . ./venv/bin/activate;
MODULE_NAME = foo

TEST_DOCKER_IMAGE = pybase_test

.PHONY: help
.DEFAULT_GOAL: help

help:
	@echo "These are public command list (\`・ω・´)"
	@grep -E '^[a-zA-Z_%-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean: clean_venv ## Cleaning up your environment

setup: build_test_image ## Setup test environment

development: venv install install_dev ## Setup for local development

test: lint_python test_python

# Python
clean_venv:
	rm -rf venv

venv:
	$(PYTHON) -m venv venv
	echo '../../../../lib' > ./venv/lib/python3.6/site-packages/lib.pth

install: venv
	$(ACTIVATE) pip install -r requirements.txt -c constraints.txt

install_dev: venv
	$(ACTIVATE) pip install -r requirements-dev.txt -c constraints.txt

freeze: venv  ## Freeze pip modules into constraints.txt
	$(ACTIVATE) pip freeze > constraints.txt

build_test_image:
	docker build -t $(TEST_DOCKER_IMAGE) .

lint_python: build_test_image
	docker run -it $(TEST_DOCKER_IMAGE) sh -c 'flake8 foo'

test_python: build_test_image
	docker run -it $(TEST_DOCKER_IMAGE) sh -c 'py.test -sv foo'
