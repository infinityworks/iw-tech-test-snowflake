# Snowflake Data Engineer Tech Test

## Introduction

This assessment is designed for candidates to demonstrate their knowledge of good software and data engineering practices. Please complete the assessment task at home, it should take around 2-3 hours to complete.

You can use Python to generate the required sample data (instructions for installing python on your machine, are in the links below).
[ADD LINK HERE]

### Test Instructions
The purpose of this exercise is to complete a small data pipeline that aggregates and transforms input data according to requirements driven by the data science team. The details of this are given later in this document.

Please fork this repo and build out your solution.

You will be required to have an AWS account where you can create an S3 bucket. You will also need a trial Snowflake account to complete the task.

The aim of this exercise is to write code that processes existing data sources so that it meets requirements. 
As part of solving this, we are looking to assess:
* Your problem-solving approach.
* Your ability to turn your solution into working code and choosing appropriate technology.



## Tech Test 
User Story

    Customer Shopping Patterns
    The task involves developing a data pipeline to 
    complete the user story above using sample 
    data sources that will be provided.
    Our data science team has reached out to our 
    data engineering team requesting we pre-process some 
    of the data for them at scale so that they can make better 
    use of it in their downstream algorithms. 
    They would like us to deliver this data weekly.

The input data sources are comprised of customers (in CSV format), transactions (in JSON Lines format) and products (in CSV format). Their details are presented below:

**Customers**
Contains information about customers such as the customer id and the date when they joined:
| <!-- -->    | <!-- -->      | <!-- --> | <!-- --> |
| ----------- | ------------- | -------- | -------- |
| customer_id | loyalty_score | C1       | 7        |


    As a data scientist I want to be able to consume a data source 
    that contains information about how many times each of 
    our customers buys our products in a given period, 
    so that I can predict what they will buy next.

**Transactions**
Is an ever-increasing data source that currently contains 2 years of transactions.
Each transaction contains the customer id, details of what products they purchased and the date of purchase:

```json
{
    "customer_id": "C1",
    "basket": [
        {
            "product_id": "P3",
            "price": 506
        },
        {
            "product_id": "P4",
            "price": 121
        }
    ],
    "date_of_purchase": "2018-09-01 11:09:00"
}

```
**Products**
Contains information about products such as the product id, product description and category:

| product_id | product_description | product_category |
| ---------- | ------------------- | ---------------- |
| P100       | red trousers        | C                |

### Acceptance Criteria

Create a VIEW in Snowflake to output information for every customer as follows:

| customer_id | loyalty_score | product_id | product_category | purchase_count |
| ----------- | ------------- | ---------- | ---------------- | -------------- |
| C1          | 7             | P2         | F                | 11             |
| C1          | 7             | P3         | H                | 5              |
| C2          | 4             | P9         | H                | 7              |
| C1          | 7             | P3         | H                | 5              |
| C2          | 4             | P9         | H                | 7              |


To arrive at this the following steps will need to be completed:

* Create a secure S3 bucket
* Upload data to bucket
* Ingest data from bucket to Snowflake
* Create models in Snowflake


### Further Implementation Details
The repo contains a starter project that includes the input data sources, a virtual environment with some dependencies you may find useful and some basic tests to ensure the environment is ready - but only for Python.

It is preferred to use Infrastructure-as-Code where possible for completing the above tasks. Areas of automation and improvements can be highlighted in the code. 

The code and design should meet the above requirements, and should consider future extension or maintenance by different members of the team.
