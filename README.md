# AWS VPC with Redshift peered with a Heroku Private Space

Based off of the [mars/terraform-aws-vpc-peered project](https://github.com/mars/terraform-aws-vpc-peered). 

This example provisions an AWS VPC via the [mars/heroku_aws_vpc](https://github.com/mars/terraform-aws-vpc) module, a new Private Space, peers them automatically and provisions a Redshift cluster in the AWS VPC. 

A seperate [Redshift Client](https://github.com/trevorscott/redshift-client) needs to be delpoyed manually to the private space but will be included in the TF script soon.


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

## Usage

```bash
export \
  TF_VAR_heroku_email=name@example.com \
  TF_VAR_heroku_enterprise_team=xxxxx \
  TF_VAR_heroku_api_key=xxxxx \
  TF_VAR_aws_access_key=xxxxx \
  TF_VAR_aws_secret_key=xxxxx \
  TF_VAR_instance_public_key='ssh-rsa xxxxx…' 

terraform init

terraform apply \
  -var name=my-deployment-name \
  -var aws_region=us-west-2
```

Name suggestion: `redshift-test`
