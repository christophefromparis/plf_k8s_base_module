# ------------------------
# ----- GCP specific -----
# ------------------------
variable "gcp_project" {
  description = "The GCP project name"
  default     = ""
}
variable "gcp_credentials" {
  description = "The GCP project credentials JSON file "
  default = ""
}

# ------------------------
# ----- AWS specific -----
# ------------------------
variable "aws_default_region" {
  description = "The default AWS region"
  default     = ""
}
variable "eks_node_arn" {
  description = ""
  default     = ""
}

# ------------------------
# ----- The cluster ------
# ------------------------
variable "cluster_provider" {
  description = "The Kubernetes cluster provider (google or aws at the moment)"
}
variable "namespace_name" {
  description = "The default namespace name"
  type = "map"
}
# ------------------------
# --- The applications ---
# ------------------------
variable "helm_version" {
  type = "map"
}
variable "letsencrypt_issuer_email" {
  description = "The email provided to letsencrypt"
  default     = "christophe.cosnefroy@yelty.fr"
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
  description = "The AWS account"
  default     = "xxxxxxxxxx"
}