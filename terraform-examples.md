# How to run this Terraform script

```
terraform init

terraform plan \
  -var name=vpc-redshift \
  -var aws_region=us-west-2 \
  -var redshift_client_app_name=redshift-client

terraform apply \
  -var name=vpc-redshift \
  -var aws_region=us-west-2 \
  -var redshift_client_app_name=redshift-client \
```


# Destroy Resources Examples
```
# destroy everything
terraform destroy \
  -var name=vpc-redshift \
  -var aws_region=us-west-2 \
  -var redshift_client_app_name=redshift-client

# destroy redshift subnet group
terraform destroy -target aws_redshift_subnet_group.my_redshift_subnet_group \
 -var name=vpc-redshift \
  -var aws_region=us-west-2 \
  -var redshift_client_app_name=redshift-client

# destroy redshift cluster
terraform destroy -target aws_redshift_cluster.tf_redshift_cluster \
 -var name=vpc-redshift \
  -var aws_region=us-west-2 \
  -var redshift_client_app_name=redshift-client 

# destroy redshift client heroku app
terraform destroy -target heroku_app.redshift_client \
 -var name=vpc-redshift \
  -var aws_region=us-west-2 \
  -var redshift_client_app_name=redshift-client 
```