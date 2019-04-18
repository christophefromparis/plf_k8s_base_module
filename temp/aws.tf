data "template_file" "roles-config-map" {
  template = "${file("${path.module}/files/aws_auth_roles_config_map.yaml")}"

  vars {
    worker_role = "${data.terraform_remote_state.infra.eks-node-arn}"
  }
}

# todo: Create the AWS user 'bitbucket' with terraform
data "template_file" "users-config-map" {
  template = "${file("${path.module}/files/aws_auth_users_config_map.yaml")}"

  vars {
    cicd_user = "arn:aws:iam::${var.aws_account}:user/bitbucket"
  }
}

resource "kubernetes_config_map" "aws-auth" {
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