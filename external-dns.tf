locals {
  values-filename = "${path.module}/files/${var.dns_provider}-external-dns-values.yml"
}

# ---  We prepare the external-dns values.yaml ---
data "template_file" "external-dns" {
  template = "${file(local.values-filename)}"

  vars {
    external-dns-filter = "${data.terraform_remote_state.infra.fqdn_suffix}"
    aws_region          = "${data.terraform_remote_state.infra.aws_default_region}"
    gcp_project         = "${var.gcp_project}"
    gcp_credentials     = "${var.gcp_credentials}"
  }
}

# --- We install the external DNS manager ---
resource "helm_release" "external-dns" {
  name      = "external-dns"
  chart     = "stable/external-dns"
  version   = "${lookup(var.helm_version, "external-dns")}"
  namespace = "${var.global_namespace}"
  timeout   = 600

  values = [
    "${data.template_file.external-dns.rendered}"
  ]

  depends_on = ["null_resource.refresh_chart_repo"]
}