MODE ?= SCRIPT

ifeq ($(MODE),SCRIPT)
build:
	@echo "Not implemented yet"
else ifeq ($(MODE),PACKAGE)
build: build-default
	@mkdir -p $(BUILD_ARTIFACT_DIR)
	@find $(ROOT_MAKEFILE_DIR)/dist -name '*.whl' -exec mv {} $(BUILD_ARTIFACT_DIR)/ \;
	@rm -Rf $(ROOT_MAKEFILE_DIR)/dist/
else
build:
	@echo "Not implemented yet"
endif
