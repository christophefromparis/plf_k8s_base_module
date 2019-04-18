# --- We create the namespaces ---
resource "kubernetes_namespace" "monitoring" {
  metadata {

    labels {
      created-by = "Terraform"
    }

    name = "${var.monitoring_namespace}"
  }
}

resource "kubernetes_namespace" "dev" {
  metadata {

    labels {
      created-by = "Terraform"
    }

    name = "${var.development_namespace}"
  }
}

resource "kubernetes_namespace" "staging" {
  metadata {

    labels {
      created-by = "Terraform"
    }

    name = "staging"
  }
}

resource "kubernetes_namespace" "production" {
  metadata {

    labels {
      created-by = "Terraform"
    }

    name = "production"
  }
}

resource "kubernetes_namespace" "global" {
  metadata {

    labels {
      created-by = "Terraform"
      "certmanager.k8s.io/disable-validation" = "true"
    }

    name = "${var.global_namespace}"
  }
}

resource "kubernetes_storage_class" "ssd" {
  count = "${var.cluster_provider == "google" ? 1 : 0}"
  metadata {
    name = "ssd"
  }
  storage_provisioner = "kubernetes.io/gce-pd"
  reclaim_policy = "Retain"
  parameters {
    type = "pd-ssd"
  }
}