# --- The information to retrieve the infra remote state
infra_backend       = "gcs"
bucket_backend      = "tf-state-infra-gcp"
prefix_backend      = "terraform/state"
credentials_backend = "./secrets/gcp-credentials.json"

dns_provider  = "google"