#!/bin/bash

# This script is list all the components from the 'repository.yaml' under the same resource_type passed as an argument.
# The script uses 'yq' to parse the yaml file.
# The same resource_type can't exist twice under the same layer

# Usage: ./list_resources.sh <repository.yaml location> <resource_type>

resource_type=$2 yq eval '.layers | (.[] | select(. != null) ) as $i ireduce({}; .[$i | .name] = ($i | .resources[] | select(.resource_type == env(resource_type)) |  .name as $resource_name | .components | map("\($i |.name)/\($resource_name)/\(.)") )) | .[] | select(. != null)[]' $1;
