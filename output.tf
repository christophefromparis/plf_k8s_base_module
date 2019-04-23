output "aws_account" {
  value = "${var.aws_account}"
}

output "monitoring_ns" {
  value = "${kubernetes_namespace.monitoring.id}"
}

output "test" {
  value = "${var.gcp_credentials}"
}