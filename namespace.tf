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

data "template_file" "roles-config-map" {
  count = "${var.cluster_provider == "aws" ? 1 : 0}"
  template = "${file("${path.module}/files/aws_auth_roles_config_map.yaml")}"

  vars {
    worker_role = "${var.eks_node_arn}"
  }
}

# todo: Create the AWS user 'bitbucket' with terraform
data "template_file" "users-config-map" {
  count = "${var.cluster_provider == "aws" ? 1 : 0}"
  template = "${file("${path.module}/files/aws_auth_users_config_map.yaml")}"

  vars {
    cicd_user = "arn:aws:iam::${var.aws_account}:user/bitbucket"
  }
}

resource "kubernetes_config_map" "aws-auth" {
  count = "${var.cluster_provider == "aws" ? 1 : 0}"
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
    labels {
      created-by = "Terraform"
    }
  }

  data {
    mapRoles = "${data.template_file.roles-config-map.rendered}"
    mapUsers = "${data.template_file.users-config-map.rendered}"
  }
}