

### GCP

````bash
terraform init -backend-config=backend.gcp.dev.tfvars
terraform plan -var-file=gcp.variables.tfvars -out=base.gcp.plan
terraform apply base.gcp.plan
````

### AWS

````bash
terraform init -backend-config=backend.aws.dev.tfvars
terraform plan -var-file=aws.variables.tfvars -out=base.aws.plan
terraform apply base.aws.plan
````
