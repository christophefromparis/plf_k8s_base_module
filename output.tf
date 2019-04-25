output "aws_account" {
  value = "${var.aws_account}"
}

output "monitoring_ns" {
  value = "${kubernetes_namespace.monitoring.id}"
}

output "global_ns" {
  value = "${kubernetes_namespace.global.id}"
}

output "developement_ns" {
  value = "${kubernetes_namespace.dev.id}"
}

output "staging_ns" {
  value = "${kubernetes_namespace.staging.id}"
}

output "production_ns" {
  value = "${kubernetes_namespace.production.id}"
}

output "stable_helm_repository" {
  value = "${data.helm_repository.stable.name}"
}