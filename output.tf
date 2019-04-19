/*output "fqdn_suffix" {
  value = "${data.terraform_remote_state.infra.fqdn_suffix}"
}

output "creator_label" {
  value = "${data.terraform_remote_state.infra.creator_label}"
}*/

output "aws_account" {
  value = "${var.aws_account}"
}

/*output "bitbucket_data" {
  value = "${data.kubernetes_secret.bitbucket-pipeline.data}"
}*/
