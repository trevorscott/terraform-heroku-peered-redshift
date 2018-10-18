# AWS VPC with Redshift peered with a Heroku Private Space

Based off of the [mars/terraform-aws-vpc-peered project](https://github.com/mars/terraform-aws-vpc-peered). 

This example uses Terraform to provision an AWS VPC via the [mars/heroku_aws_vpc](https://github.com/mars/terraform-aws-vpc) module, a new Private Space, peers them automatically and provisions a Redshift cluster in the AWS VPC. 

When the Terraform script runs, an example [Redshift Client](https://github.com/trevorscott/redshift-client) is delpoyed to the private space as well.


![Diagram of example private space app connecting to a Redshift Cluster in a peered AWS VPC](doc/terraform-heroku-peered-redshift.png)

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

```bash
export \
  TF_VAR_heroku_email='your-heroku-email' \
  TF_VAR_heroku_enterprise_team='your-enterprise-team-name' \
  TF_VAR_heroku_api_key='run heroku auth:token' \
  TF_VAR_aws_access_key='IAM user aws access key' \
  TF_VAR_aws_secret_key='IAM user aws secret key' \
  TF_VAR_redshift_dbname='name of redshift db' \
  TF_VAR_redshift_username='redshift username' \
  TF_VAR_redshift_password='redshift password' 
```

Its best to keep these handy in a `.env` file, ignored by git.

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

Once the Terraform script has successfully provisioned, there will be two outputs:

```
heroku_app_name = <your heroku app name>
redshift_url = <your redshift cluster database URL>
```

To ensure that your heroku app has successfully connected to redshift, copy the `heroku_app_name` value and run this command to check the logs:

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
