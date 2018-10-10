output "redshift_url" {
  value = "jdbc:redshift//${aws_redshift_cluster.tf_redshift_cluster.dns_name}:5439"
}
