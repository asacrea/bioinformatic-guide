# Bronze Appflow ETL Glue Job

Single general glue job that transfers the data from landing bucket to bronze tables and accepts required_columns,
s3_landing_bucket, s3_datalake_bucket, input_prefix, layer, source, table, purge_s3, purge_retention_period,
input_file_format and required_parameters as parameters.

## Dependencies
 - aws-glue-libs
 - awsglue_deps
 - glue_utils
## Commands

`make init`

- This command facilitates the initial setup by pulling necessary images and resolving dependencies listed in the lock file.


`make lint`

- This commands lints the code using ryff.

`make build`

- This command builds and packages your glue job
