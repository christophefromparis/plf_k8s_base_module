# --- Providers ---
provider "aws" {
  version = "~> 2.2.0"
  region = "${var.aws_default_region}"
}

provider "kubernetes" {
  version = "~> 1.5.2"
  host    = "${var.cluster_endpoint}"
}

provider "helm" {
  version = "~> 0.9.0"
  service_account = "${kubernetes_service_account.tiller.metadata.0.name}"
}

provider "template" {
  version = "~> 2.1"
}

provider "null" {
  version = "~> 2.1"
}
