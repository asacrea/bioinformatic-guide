# Bioinformatic formats Data Ingestion

Single general glue job that transfers the data from a locally path to bronze tables, also a notebook spark processing is included to see some of the most common use cases.

## Dependencies
 - bio-pyspark

## Commands

`make init`

- This command facilitates the initial setup by pulling necessary images and resolving dependencies listed in the lock file.


`make lint`

- This commands lints the code using ryff.
