# --- The information to retrieve the infra remote state
infra_backend  = "s3"
region_backend = "eu-west-1"
bucket_backend = "veolia-vwis-infra-irl-terraform"
key_backend    = "dev.k8s.infra.tfstate"

dns_provider  = "aws"