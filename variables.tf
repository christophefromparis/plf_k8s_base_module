
variable "infra_backend" {
  description = "The backend type (s3 or gcs)"
}

variable "bucket_backend" {
  description = "The bucket who hosted the infra tfstate"
}

variable "prefix_backend" {
  description = "The gcs prefix who hosted the infra tfstate"
  default = ""
}

variable "region_backend" {
  description = "The s3 region who hosted the infra tfstate"
  default = ""
}

variable "key_backend" {
  description = "The s3 key who hosted the infra tfstate"
  default = ""
}

# ------------------------
# ----- GCP specific -----
# ------------------------

variable "gcp_project" {
  description = "The GCP project name"
  default     = ""
}
variable "gcp_credentials" {
  description = "The GCP project credentials"
  default = ""
}

# ------------------------
# ----- The cluster ------
# ------------------------

variable "cluster_endpoint" {
  description = "The Kubernetes cluster endpoint"
}

# ------------------------
# --- The applications ---
# ------------------------

variable "global_namespace" {
  description = "The namespace name who hosted the global component"
  default     =  "global"
}

variable "monitoring_namespace" {
  description = "The namespace name who hosted the monitoring component"
  default     =  "monitoring"
}

variable "development_namespace" {
  description = "The namespace name who hosted the developments"
  default     =  "dev"
}

variable "helm_version" {
  type = "map"

  default = {
    cert-manager  = "v0.6.6"
    external-dns  = "1.7.0"
    nginx-ingress = "1.4.0"
    prometheus    = "8.9.0"
  }
}

variable "letsencrypt_issuer_email" {
  description = "The email provided to letsencrypt"
  default     = "christophe.cosnefroy.ext@veolia.com"
}

variable "letsencrypt_env" {
  description = "The Let'sEncrypt environement"
  #default     = "letsencrypt-staging"
  default     = "letsencrypt-prod"
}

variable "letsencrypt_endpoint" {
  description = "The Let's Encrypt endpoint"
  #default     = "https://acme-staging-v02.api.letsencrypt.org/directory"
  default     = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "dns_provider" {
  description = "The DNS provider (aws or google)"
}

# ------------------------
# ---       CI-CD      ---
# ------------------------

variable "pipeline_sa_name" {
  description = "The Service Account name used by the Bitbucket pipelines"
  default     = "bitbucket-pipeline"
}

variable "deploy_role_name" {
  description = "The Role name authorized to deploy"
  default     = "deploy"
}

variable "aws_account" {
  description = "The AWS Veolia account"
  default     = "665901990640"
}