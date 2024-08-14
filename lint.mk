SRC = $(shell find . -name '*.py' -not -path './.venv/*' -not -path './.build/*' -not -path './dist/*' -not -path './out/*' -not -path './awsglue/*')

PYPROJECT_TOML = "$(ROOT)/pyproject.toml"

# find .pylintrc file at parent folders recursively until first is found
PYLINT_CONFIG = "$(shell while [ "$$(pwd)" != "/" ] && [ ! -f .pylintrc ]; do cd ..; done; pwd)/.pylintrc"

lint: lint-ruff lint-pylint lint-mypy

lint-pylint:
	$(PYLINT_ENV) poetry run pylint $(SRC) --rcfile $(PYLINT_CONFIG) --fail-under=8 --fail-on=E  --output-format="colorized"

lint-ruff:
	@poetry run ruff check --fix

lint-mypy:
	@poetry run mypy $(SRC) --config-file $(PYPROJECT_TOML) --namespace-packages --explicit-package-bases --show-column-numbers
