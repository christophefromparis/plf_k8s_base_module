# --- We create the namespaces ---
resource "kubernetes_namespace" "monitoring" {
  metadata {

    labels {
      created-by = "Terraform"
    }

    name = "${lookup(var.namespace_name, "monitoring")}"
  }
}

resource "kubernetes_namespace" "dev" {
  metadata {

    labels {
      created-by = "Terraform"
    }

    name = "${lookup(var.namespace_name, "dev")}"
  }
}

resource "kubernetes_namespace" "staging" {
  metadata {

    labels {
      created-by = "Terraform"
    }

    name = "${lookup(var.namespace_name, "stage")}"
  }
}

resource "kubernetes_namespace" "production" {
  metadata {

    labels {
      created-by = "Terraform"
    }

    name = "${lookup(var.namespace_name, "prod")}"
  }
}

resource "kubernetes_namespace" "global" {
  metadata {

    labels {
      created-by = "Terraform"
      "certmanager.k8s.io/disable-validation" = "true"
    }

    name = "${lookup(var.namespace_name, "global")}"
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