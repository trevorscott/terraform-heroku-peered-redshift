# AWS VPC + Redshift peered with a Heroku Private Space

This example uses Terraform to create:
1. An AWS VPC
1. A Redshift cluster in that VPC
1. A Heroku Private Space peered with that VPC

Additionally, a basic [Redshift Client](https://github.com/trevorscott/redshift-client) Heroku app is delpoyed to the Private Space. When the app starts, it establishes a connection to Redshift through the Peered VPC Connection and outputs success / failure in the logs.

![Diagram of example private space app connecting to a Redshift Cluster in a peered AWS VPC](doc/terraform-heroku-peered-redshift.png)

This example was based off of [mars/terraform-aws-vpc-peered project](https://github.com/mars/terraform-aws-vpc-peered) and directly uses
[mars/heroku_aws_vpc](https://github.com/mars/terraform-aws-vpc).

## Requirements

1. A Heroku Enterprise Account
1. An [AWS IAM](https://console.aws.amazon.com/iam/home) user (`aws_access_key` & `aws_secret_key` in Usage below).

With policies:
* **AmazonEC2FullAccess**
* **AmazonECS_FullAccess**
* **AmazonVPCFullAccess**
* **IAMFullAccess**
* **CloudWatchLogsFullAccess**
* **AmazonRedshiftFullAccess**

## Required Config

You will need to set the following enviornment variables locally:

```bash
export \
  TF_VAR_heroku_email='your-heroku-email' \
  TF_VAR_heroku_enterprise_team='your-enterprise-team-name' \
  TF_VAR_heroku_api_key='run heroku auth:token' \
  TF_VAR_aws_access_key='IAM user aws access key' \
  TF_VAR_aws_secret_key='IAM user aws secret key' \
  TF_VAR_redshift_dbname='name of redshift db you would like to create' \
  TF_VAR_redshift_username='master redshift username you would like to create' \
  TF_VAR_redshift_password='master redshift user password' 
```

Tip: Its best to keep the above env vars handy in a `.env` file so you can reference them later, if needed.

## Usage

```bash
terraform init
```

Choose a deployment name. Keep it short as your resources will be prefixed by the chosen name.
```
terraform apply \
  -var name=<your-deployment-name> \
  -var aws_region=us-west-2
```


## Check Connection Health

Once the Terraform apply has completed successfully, there will be two outputs:

```
Outputs:
heroku_app_name = <your heroku app name>
redshift_url = <your redshift cluster database URL>
```

To ensure that your heroku app has successfully connected to redshift, copy / paste your app name into this command:

```
heroku logs -t -a <your heroku app name>
```

You should see 
```
Successfully connected to AWS Redshift Cluster: <your redshift cluster database URL>
```

Alternatively you can run a one off dyno to check the health of the redshift connection:

```
heroku run node redshift-client.js -a <your heroku app name>
```
