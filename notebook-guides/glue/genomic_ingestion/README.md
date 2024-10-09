# Bioinformatic formats Data Ingestion

This folder contains a PySpark module designed for performing ETL (Extract, Transform, Load) processes on various bioinformatics data formats, such as FASTA, VCF, and GFF/GTF. The module demonstrates how to efficiently handle and transform large-scale biological datasets, ensuring they are ready for downstream analysis.

The ETL pipeline is optimized for distributed computing environments and leverages PySpark's capabilities to process bioinformatics data at scale. This guide provides practical code examples and workflows to streamline data engineering tasks in bioinformatics.

Single general glue job that transfers the data from a locally path to bronze tables, also a notebook spark processing is included to see some of the most common use cases.

## Dependencies
 - bio-pyspark

## Commands

`make init`

- This command facilitates the initial setup by pulling necessary images and resolving dependencies listed in the lock file.


`make lint`

- This commands lints the code using ruff.

`make test_in_jupyter_locally`

- This commands execute a AWS Glue local environment using docker. Be sure to have docker intalled on your computer and have the docker daemon running.
