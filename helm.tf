resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = "tiller"
    namespace = "kube-system"
  }

  depends_on = ["kubernetes_service_account.tiller"]
}

resource "null_resource" "correct_sa" {
  triggers {
    build_number = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "kubectl -n kube-system patch sa tiller -p '{\"automountServiceAccountToken\": true}'"
  }

  depends_on = ["kubernetes_cluster_role_binding.tiller"]
}

resource "null_resource" "init_helm" {
  triggers {
    build_number = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "helm init --upgrade --service-account tiller; sleep 5;"
  }

  depends_on = ["null_resource.correct_sa"]
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"

  depends_on = ["null_resource.init_helm"]
}

#--- We refresh the Helm local repository before to install Charts
resource "null_resource" "refresh_chart_repo" {
  triggers {
    build_number = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "helm repo update"
  }

  depends_on = ["data.helm_repository.stable"]
}