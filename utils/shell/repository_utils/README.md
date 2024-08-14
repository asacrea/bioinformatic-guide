# Repository utils

This directory contains utility scripts for working with repository files.

---

## list_resources.sh

### Dependencies

- [yq](https://mikefarah.gitbook.io/yq) v4.44.2

### Description

This script is based on `yq`, a command-line YAML processor, that is used to parse a YAML file named `repository.yaml`. The script is designed to extract the list of the components paths (repository level) based on a given resource type.

The first part of the command `resource_type=$1` sets the variable `resource_type` to the first argument passed to the script. This is the resource type that will be extracted.

The first operation `.layers | (.[] | select(. != null) ) as $i` goes through each layer in the YAML file and assigns it to the variable `$i`, but only if the layer is not null.

The next operation `ireduce({}; .[$i | .name] = ($i | .resources[] | select(.resource_type == env(resource_type))` constructs a new object for each layer. This object has keys that are the names of the layers and values that are the list of resources of the given type in that layer.

The `map("\($i |.name)\\\($resource_name)\\\(.)")` operation then maps each component of the resource to a string that includes the layer name, the resource name, and the component itself.

Finally, the `| .[] | select(. != null)[]` operation flattens the resulting array and removes any null values.

### Usage

```bash
./list_resources.sh <repository.yaml location> <resource_type>
```

### Example

From the `repository.yaml` file:

```yaml
layers:
  - name: data_ingestion
    resources:
      - name: glue
        resource_type: glue
        components:
          - bronze_appflow_etl
          - bronze_redshift_etl
  - name: shared
    resources:
      - name: python
        resource_type: python
        components:
          - development_package
  - name: utils
    resources:
      - name: glue
        resource_type: glue
        components:
          - initialize_delta_tables
      - name: glue-job
        resource_type: glue
        components:
          - dummy_glue_job
      - name: lambda
        resource_type: lambda
        components:
          - run_trino_queries
```

The following example will list all the glue jobs defined in the `repository.yaml` file.

```bash
./list_resources.sh ./repository.yaml glue
```

The output of the command will be a list of the paths at repository level for each component of the given resource type:

```
data_ingestion/glue/bronze_appflow_etl
data_ingestion/glue/bronze_redshift_etl
utils/glue/initialize_delta_tables
utils/glue-job/dummy_glue_job
```

---
