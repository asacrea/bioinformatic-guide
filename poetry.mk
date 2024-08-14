.venv:
	python3 -V | grep $(PYTHON_VERSION). || (echo "Invalid python version installed: $(python3 -V). Expected $(PYTHON_VERSION).*" && exit 1)
	python -m venv .venv

# Create virtual environment and install package dependencies
init:
	poetry lock --no-update && poetry install --sync

# Update/install package dependencies
install:
	poetry update && poetry install --sync

# Build package
build-default:
	poetry build

test-default:
	@echo "Not implemented yet"
