# --- Providers ---
provider "aws" {
  version = "~> 2.2.0"
  region = "${var.aws_default_region}"
}

provider "template" {
  version = "~> 2.1"
}

provider "null" {
  version = "~> 2.1"
}
