include ../../../shared.mk

GLUE_VERSION ?= glue_libs_4.0.0_image_01
GLUE_ENV ?= local
PROFILE_NAME ?= xxx-xxx
IMAGE_TAG ?= glue_v$(GLUE_VERSION):latest
PARAMETERS_FILE_NAME ?= job_parameters.json
NOTEBOOK_PARAMETERS_FILE ?= notebook_parameters.json

# Get the current directory
CURRENT_DIR := "$(shell pwd)"
# Get the parent directory of the current directory
JOB_PARENT_DIR := "$(shell dirname $(CURRENT_DIR))"
# Get the current folder
CURRENT_FOLDER := $(lastword $(subst /, ,$(shell pwd)))
# Get the .py file
SCRIPT_JOB_FILE := $(CURRENT_FOLDER)/src/job.py

# This function Extracts key-value pairs from a JSON file using jq and returns them as a formatted string.
get_job_parameters_json = $$(jq -r 'to_entries | .[] | "\(.key) \(.value)"' $(1))

# This function Extracts key-value pairs from a YAML file using yq and returns them as a formatted string.
get_job_parameters_yaml = $$(yq -r 'to_entries | .[] | "\(.key) \(.value)"' $(1))

# This function Generates a list of command-line arguments from key-value pairs in a JSON file using jq, where each key-value pair is passed as an argument.
get_notebook_parameters_json = $(foreach key,$(shell jq -r 'keys[]' $(1)),-e $(key)="$(shell jq -r .$(key) $(1))")

# This function Generates a list of command-line arguments from key-value pairs in a YAML file using yq, where each key-value pair is passed as an argument.
get_notebook_parameters_yaml = $(foreach key,$(shell yq -r 'keys[]' $(1)),-e $(key)="$(shell jq -r .$(key) $(1))")

# Rule to select the appropriate function according to the suffix of the job parameters file
select_get_job_parameters_function = $(if $(filter $(suffix $1),.json),$(call get_job_parameters_json, $(1)),$(if $(filter $(suffix $1),.yaml),$(call get_job_parameters_yaml, $(1)),$(error "Unrecognized file")))

# Rule to select the appropriate function according to the suffix of the notebook parameters file
select_get_notebook_parameters_function = $(if $(filter $(suffix $1),.json),$(call get_notebook_parameters_json, $(1)),$(if $(filter $(suffix $1),.yaml),$(call get_notebook_parameters_yaml, $(1)),$(error "Unrecognized file")))

package_docker_glue:
	(cd $(ROOT)/shared/resources/glue/ && docker build \
	-f glue.dockerfile \
	--build-arg GLUE_VERSION=$(GLUE_VERSION) \
	-t $(IMAGE_TAG) .)

run_docker_job_locally: package_docker_glue
	docker run \
		-v $(ROOT)/shared/:/app/shared/ \
		-v $(CURRENT_DIR):/app/layer/glue/$(CURRENT_FOLDER)/ \
		-e AWS_SECRET_ACCESS_KEY=$(call get_aws_parameter,aws_secret_access_key) \
		-e AWS_ACCESS_KEY=$(call get_aws_parameter,aws_access_key_id) \
		-e AWS_REGION=$(call get_aws_parameter,region) \
		$(IMAGE_TAG) \
		spark-submit /app/layer/glue/$(SCRIPT_JOB_FILE) $(call select_get_job_parameters_function, test/$(PARAMETERS_FILE_NAME))

test_in_jupyter_locally: package_docker_glue
	docker run -it \
	-v ~/.aws:/home/glue_user/.aws \
	-v $(ROOT)/shared/resources/glue:/home/glue_user/resources/glue/ \
	-v $(CURRENT_DIR):/home/glue_user/workspace/jupyter_workspace/ \
	-e AWS_PROFILE=$(PROFILE_NAME) \
	$(call select_get_notebook_parameters_function, test/$(NOTEBOOK_PARAMETERS_FILE)) \
	-e DISABLE_SSL=true \
	--rm -p 4040:4040 -p 18080:18080 -p 8998:8998 -p 8888:8888 \
	--name glue_jupyter_lab $(IMAGE_TAG) /home/glue_user/jupyter/jupyter_start.sh
test:
	@echo "Not implemented yet."
