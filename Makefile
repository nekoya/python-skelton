PYTHON = python3.6
ACTIVATE = . ./venv/bin/activate;
MODULE_NAME = foo

.PHONY: help
.DEFAULT_GOAL: help

help:
	@echo "These are public command list (\`・ω・´)"
	@grep -E '^[a-zA-Z_%-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean: clean_venv ## Cleaning up your environment

setup: venv install install_dev ## Setup your environment

test: test_python ## Testing

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

lint:
	$(ACTIVATE) flake8 $(MODULE_NAME)

test_python: lint
	$(ACTIVATE) py.test $(MODULE_NAME)
