
resource "aws_redshift_subnet_group" "my_redshift_subnet_group" {
  name       = "my-redshift-subnet-group"
  subnet_ids = ["${module.heroku_aws_vpc.private_subnet_id}"]
  tags {
    environment = "Production"
  }
}

resource "aws_security_group" "redshift_sg" {
  name   = "redshift-sg"
  vpc_id = "${module.heroku_aws_vpc.id}"

  # Allow ingress rules to be accessed only within current VPC
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["${data.heroku_space_peering_info.default.vpc_cidr}"]
  }
}

# adding route as specified from docs:
# https://docs.aws.amazon.com/vpc/latest/peering/vpc-peering-routing.html
resource "aws_route" "private_vpc_route" {
  route_table_id            = "${module.heroku_aws_vpc.private_route_table_id}"
  destination_cidr_block    = "${data.heroku_space_peering_info.default.vpc_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.request.id}"
}


# Single Node Redshift cluster 
resource "aws_redshift_cluster" "tf_redshift_cluster" {
  cluster_identifier  = "tf-redshift-cluster"
  database_name       = "mydb"
  master_username     = "${var.redshift_username}"
  master_password     = "${var.redshift_password}"
  node_type           = "dc1.large"
  cluster_type        = "single-node"
  publicly_accessible = "false" 
  skip_final_snapshot = "true"
  cluster_subnet_group_name = "${aws_redshift_subnet_group.my_redshift_subnet_group.name}"
  vpc_security_group_ids  = ["${aws_security_group.redshift_sg.id}"]
}

// deploy app to space
// create heroku postgres database, attach to app
// return redshift dburl as config var

