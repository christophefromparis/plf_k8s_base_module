data "terraform_remote_state" "infra" {
  backend = "${var.infra_backend}"
  config {
    bucket      = "${var.bucket_backend}"
    credentials = "${var.credentials_backend}"
    key         = "${var.key_backend}"
    region      = "${var.region_backend}"
  }
}

terraform {
  required_version = "~> 0.11.13"
  backend "s3" {
  }
}

# --- Providers ---
provider "aws" {
  version = "~> 2.2.0"
  region = "${data.terraform_remote_state.infra.aws_default_region}"
}

provider "kubernetes" {
  version = "~> 1.5.2"
  host = "${var.eks-cluster-endpoint}"
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
