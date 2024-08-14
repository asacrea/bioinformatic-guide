PROJECT = glue-assets

POETRY_VERSION := 1.8.2
PYTHON_VERSION = $(shell cat .python-version)

# Shared AWS Account ID to store all artifacts
AWS_ACCOUNT_ID = XXXXXX
AWS_REGION = XXXXX
# Root repository directory
ROOT = $(shell git rev-parse --show-toplevel)

# Root directory for coverage reports for aggregation later
COVERAGE_DIR = $(ROOT)/.coverage_reports
$(COVERAGE_DIR):
	mkdir -p $(COVERAGE_DIR)

# Root directory for build artifacts
BUILD_DIR = $(ROOT)/.build

# ignore `.mk` includes, get `Makefile` path
ROOT_MAKEFILE_PATH := $(abspath $(firstword $(MAKEFILE_LIST)))
# get `Makefile` directory
ROOT_MAKEFILE_DIR := $(dir $(ROOT_MAKEFILE_PATH))

# get component, resource, and layer directories
COMPONENT_DIR = $(ROOT_MAKEFILE_DIR)
RESOURCE_DIR = $(shell dirname $(ROOT_MAKEFILE_DIR))
LAYER_DIR = $(shell dirname $(RESOURCE_DIR))

COMPONENT = $(shell basename $(COMPONENT_DIR))
RESOURCE = $(shell basename $(RESOURCE_DIR))
LAYER = $(shell basename $(LAYER_DIR))

BUILD_ARTIFACT_DIR = $(BUILD_DIR)/$(LAYER)/$(RESOURCE)/$(COMPONENT)/

get_job_parameters = $$(jq -r 'to_entries | .[] | "\(.key) \(.value)"' $(1))
get_notebook_parameters = $(foreach key,$(shell jq -r 'keys[]' $(1)),-e $(key)="$(shell jq -r .$(key) $(1))")
