# Variables
include lint.mk
include poetry.mk
include shared.mk

PYTHON_VERSION = $(shell cat .python-version)

PROFILE_NAME ?= xxx-xxx

.PHONY: clean build-zip clean-dist package-docker

.PHONY: check
check:
	@echo "Checking Poetry lock file consistency with 'pyproject.toml': Running poetry check --lock"
	@poetry check --lock
	@echo "Running pre-commit checks..."
	@poetry run pre-commit run --all-files

clean: clean-dist clean-build
clean-all: clean

clean-dist:
	rm -rf dist

clean-build:
	rm -rf dist/.build

.PHONY: check-pyenv
check-pyenv:
	@echo "Checking if pyenv is installed..."
	@command -v pyenv >/dev/null 2>&1 || { echo >&2 " ------------- pyenv is not installed. Please install pyenv before proceeding."; exit 1; }
	@echo " ------------- pyenv is installed ------------- "

.PHONY: check-poetry
check-poetry:
	@echo "Checking if Poetry is installed..."
	@command -v poetry >/dev/null 2>&1 || { echo >&2 "Poetry is not installed. Please install Poetry before proceeding."; exit 1; }
	@echo " ------------- Poetry is installed ------------- "

.PHONY: install-python
install-python:
	@echo "Installing Python version $(PYTHON_VERSION) using pyenv"
	@pyenv install -s $(PYTHON_VERSION)
	@eval "$(pyenv init -)"

.PHONY: set-local-python
set-local-python:
	@echo "Setting local Python version to $(PYTHON_VERSION)"
	@pyenv local $(PYTHON_VERSION)

.PHONY: verify-python-version
verify-python-version:
	@echo "Verifying Python version..."
	@python --version | grep $(PYTHON_VERSION) || (echo "Invalid python version installed: $(python --version). Expected $(PYTHON_VERSION).*" && exit 1)
	@echo " ------------- Python version verified ------------- "

.PHONY: setup
setup: check-pyenv check-poetry install-python set-local-python verify-python-version init-pre-commit
	@echo " ------------- Setup completed ------------- "

init-pre-commit:
	poetry run pre-commit install --hook-type pre-commit --hook-type pre-push

format:
	poetry run pre-commit run --all-files --hook-stage push

list-pyspark-components:
	@command bash ./utils/shell/repository_utils/src/list_resources.sh $(ROOT)/repository.yaml pyspark

list-python-components:
	@command bash ./utils/shell/repository_utils/src/list_resources.sh $(ROOT)/repository.yaml python

build-pyspark-components:
	@for path in $(shell make list-pyspark-components); do \
		make build -C $$path; \
	done

build-python-components:
	@for path in $(shell make list-python-components); do \
		make build -C $$path; \
	done

build-all: build-pyspark-components build-python-components
