output "health_peer_internal_url" {
  value = "http://${var.name}-health.herokuapp.com"
}

output "health_internal_url" {
  value = "http://${aws_instance.health_checker.private_dns}"
}

output "health_public_url" {
  value = "http://${aws_instance.health_checker.public_dns}"
}

output "redshift_url" {
  value = "jdbc:redshift//${aws_redshift_cluster.tf_redshift_cluster.dns_name}:5439"
}
