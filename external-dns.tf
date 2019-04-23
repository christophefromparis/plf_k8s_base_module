locals {
  values-filename = "${path.module}/files/${var.dns_provider}-external-dns-values.yaml"
}

resource "kubernetes_secret" "gcp-credentials" {
  count = "${var.cluster_provider == "google" ? 1 : 0}"
  metadata {
    name      = "gcp-credentials"
    namespace = "${kubernetes_namespace.global.id}"
  }

  data {
    credentials.json = "${file("${path.module}/secrets/credentials.json")}"
  }

  type = "generic"
}

# ---  We prepare the external-dns values.yaml ---
data "template_file" "external-dns" {
  template = "${file(local.values-filename)}"

  vars {
    aws_default_region  = "${var.aws_default_region}"
    gcp_project         = "${var.gcp_project}"
    gcp_credentials     = "${kubernetes_secret.gcp-credentials.metadata.0.name}"
  }
}

# --- We install the external DNS manager ---
resource "helm_release" "external-dns" {
  name      = "external-dns"
  chart     = "stable/external-dns"
  version   = "${lookup(var.helm_version, "external-dns")}"
  namespace = "${kubernetes_namespace.global.id}"
  timeout   = 600

  values = [
    "${data.template_file.external-dns.rendered}"
  ]

  depends_on = ["null_resource.refresh_chart_repo"]
}