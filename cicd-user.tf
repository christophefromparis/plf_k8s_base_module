resource "kubernetes_service_account" "bitbucket-pipeline" {
  metadata {
    name      = "${var.pipeline_sa_name}"
    namespace = "${kubernetes_namespace.dev.id}"
  }

  depends_on = ["kubernetes_namespace.dev"]
}

data "kubernetes_secret" "bitbucket-pipeline" {
  metadata {
    name      = "${kubernetes_service_account.bitbucket-pipeline.default_secret_name}"
    namespace = "${kubernetes_namespace.dev.id}"
  }
}

resource "kubernetes_role" "deploy" {
  metadata {
    name      = "${var.deploy_role_name}"
    namespace = "${kubernetes_namespace.dev.id}"
  }
  rule {
    api_groups = ["extensions", "apps"]
    resources  = ["deployments"]
    verbs      = ["get", "update", "patch", "create"]
  }
}

resource "kubernetes_role_binding" "bitbucket-pipeline-deploy" {
  metadata {
    name      = "bitbucket-pipeline-deploy"
    namespace = "${kubernetes_namespace.dev.id}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "${var.deploy_role_name}"
    namespace = "${kubernetes_namespace.dev.id}"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "${var.pipeline_sa_name}"
    namespace = "${kubernetes_namespace.dev.id}"
  }

/*  provisioner "local-exec" {
    command = "kubectl get secret ${kubernetes_service_account.bitbucket-pipeline.default_secret_name} -n \"${var.development_namespace}\" -o jsonpath=\"{['data']['ca\\.crt']}\" | base64 -d >> ca.crt"
  }*/
}