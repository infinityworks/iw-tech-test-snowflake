# Snowflake Data Test - Starter Project

### Prerequisites

#### Python 3.8.* or later.

See installation instructions at: https://www.python.org/downloads/

Check you have python3 installed:

```bash
python3 --version
```

### Dependencies and data

#### Creating a virtual environment

Ensure your pip (package manager) is up to date:

```bash
pip3 install --upgrade pip
```

To check your pip version run:

```bash
pip3 --version
```

Create the virtual environment in the root of the cloned project:

```bash
python3 -m venv .venv
```

#### Activating the newly created virtual environment

You always want your virtual environment to be active when working on this project.

```bash
source ./.venv/bin/activate
```

#### Installing Python requirements

This will install some of the packages you might find useful:

```bash
pip3 install -r ./requirements.txt
```


#### Generating the data

A data generator is included as part of the project in `./input_data_generator/main_data_generator.py`
This allows you to generate a configurable number of months of data.
Although the technical test specification mentions 6 months of data, it's best to generate
less than that initially to help improve the debugging process.

To run the data generator use:

```bash
python ./input_data_generator/main_data_generator.py
```

This should produce customers, products and transaction data under `./input_data/starter`



#### Getting started

Please save Snowflake model code in `snowflake` and infrastructure code in `infra` folder.

Update this README as code evolves.

#### Task Notes

First, I tried to generate the data with the given condition, but it had an issue on the main_data_generator that  (bws was not defined). So I commented that bws line, once that bws was not previously defined properly.

Then, I created an S3 bucket, a Policy and a Role attached to it, so that it is possible to get the data from AWS to Snowflake securely.

Created the base tables that would get the info from the files.

Created the Storage Integration in Snowflake

Created the external stages

Populated the tables with the data from the stages

Created the final view, as required.

Created the pipes to automatically run the file as it is received.

Order of files in snowflake folder:
1 - Base_Tables.sql -- Creation of base tables
2 - storage_stage_creation.sql 
3 - Customers.sql
4 - Products.sql
5 - JSON_file_format.sql
5 - Transactions.sql
6 - Final_Table.sql
