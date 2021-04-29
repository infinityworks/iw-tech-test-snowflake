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

### Setting up infrastructure

You need to store your AWS account access details and configuration in environment variables.
To do that please run the following in your terminal:
```
export AWS_ACCESS_KEY_ID="<your access key here>"
export AWS_SECRET_ACCESS_KEY="<your secret access here>"
export REGION="<region for your environment here>" e.g. "eu-west-2".
```

You can set your production in a different region. However, it's recommended to set a region that is geographically close to the location where your snowflake account is.
Please note that the current set up does not support to set up DEV and PROD environments under different AWS accounts just yet.

Please navigate to `/infra` folder and run `terraform init`
After that, run `terraform apply`.

### Setting up Snowflake

Please sign up for a Snowflake free trial account via https://signup.snowflake.com page.
Once done, you need to export your username and snowflake account name into environment variables as following:
```
export ACCOUNT="<your snowflake account here>" e.g. "gfxxxxx.eu-west-2.aws"
export PASSWORD="<your snowflake password here>"
export USER_NAME="<your snowflake username here>"
```

To setup Snowflake E2E with data and create the view navigate to the snowflake folder `cd snowflake\` and run `python main.py -env <your environment here>` e.g. `python main.py -env DEV` or `python main.py -env PROD`
To destroy what you have created in Snowflake run `python main.py -env <your environment here> -ac destroy` e.g. `python main.py -env DEV -ac destroy` or `python main.py -env PROD -ac destroy`


what I'd change in the future are:
- modularise terraform, so one can decide to create s3 dev or prod or both
- manage terraform state files in s3
- authentication to Snowflake with key pairs
- create IAM role for Snowflake <--> s3
- introduce Secrets Managers and save creds and sensitive info there
- for modelling introduce DBT and automate its setup
- some code refactoring to build classes, add annotations and docstrings