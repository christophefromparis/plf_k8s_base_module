# ---  We prepare the Nginx values.yaml ---
data "template_file" "nginx-ingress-template" {
  template = "${file("${path.module}/files/nginx-ingress-values.yaml")}"
}

#--- NGINX Ingress Controller Helm ---
resource "helm_release" "nginx_controller" {
  name      = "nginx-controller"
  chart     = "stable/nginx-ingress"
  namespace = "${kubernetes_namespace.global.id}"
  version   = "${lookup(var.helm_version, "nginx-ingress")}"
  timeout   = "1200"

  values = [
    "${data.template_file.nginx-ingress-template.rendered}"
  ]

  set {
    name  = "rbac.create"
    value = "true"
  }
  set {
    name  = "controller.kind"
    value = "DaemonSet"
  }
  set {
    name  = "controller.stats.enabled"
    value = "true"
  }
  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }
  set {
    name  = "controller.service.enableHttps"
    value = "true"
  }
  set {
    name  = "controller.service.enableHttp"
    value = "true"
  }
  # to preserve the IP source (and so enabled the whitelisting)
  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }
  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }
  set {
    name  = "controller.publishService.pathOverride"
    value = "${kubernetes_namespace.global.id}/nginx-controller-nginx-ingress-controller"
  }
  depends_on = ["null_resource.refresh_chart_repo", "helm_release.cert-manager", "helm_release.external-dns"]
}