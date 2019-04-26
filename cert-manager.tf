resource "null_resource" "create-crd" {
  triggers {
    build_number = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.6/deploy/manifests/00-crds.yaml"
  }

  depends_on = ["kubernetes_namespace.dev"]
}

# ---  We prepare the ClusterIssuer.yaml ---
data "template_file" "cluster-isssuer" {
  template = "${file("${path.module}/files/cluster-issuer.yaml")}"

  vars {
    letsencrypt_issuer_email = "${var.letsencrypt_issuer_email}"
    letsencrypt_endpoint     = "${var.letsencrypt_endpoint}"
    letsencrypt_env          = "${var.letsencrypt_env}"
  }

  depends_on = ["null_resource.create-crd"]
}

# --- We install the certificat manager ---
resource "helm_release" "cert-manager" {
  name      = "cert-manager"
  chart     = "stable/cert-manager"
  version   = "${lookup(var.helm_version, "cert-manager")}"
  namespace = "${kubernetes_namespace.global.id}"

  set {
    name  = "rbac.create"
    value = "true"
  }
  set {
    name = "ingressShim.defaultIssuerName"
    value = "${var.letsencrypt_env}"
  }
  set {
    name  = "ingressShim.defaultIssuerKind"
    value = "ClusterIssuer"
  }
  set {
    name = "workaround"
    value = "${var.tiller_is_ready}"
  }
  provisioner "local-exec" {
    command = "kubectl create -f -<<EOF\n${data.template_file.cluster-isssuer.rendered}\nEOF"
  }

  depends_on = ["null_resource.refresh_chart_repo", "helm_release.external-dns", "null_resource.create-crd"]
}
