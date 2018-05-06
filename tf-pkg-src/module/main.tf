resource "cloudflare_record" "webapp" {
  count  = "${var.module_count}"
  domain = "${local.cloudflare_domain}"
  name   = "webapp.${var.namespace}"
  value  = "${kubernetes_service.app-service.load_balancer_ingress.0.ip}"
  type   = "A"
  ttl    = "${lookup(var.record_ttl, var.app_profile)}"
}

resource "kubernetes_service" "app-service" {
  count = "${var.module_count}"
  metadata {
    name = "app-service"
    namespace = "${var.namespace}"
  }
  spec {
    selector {
      app = "terraform-cd-example-app"
    }
    session_affinity = "ClientIP"
    port {
      port = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

data "template_file" "app-deployment" {
  template = "${file("${path.module}/manifests/app-deployment.yaml")}"

  vars {
    namespace = "${var.namespace}"
    app_version = "${var.app_version}" 
    instance_connection_name = "${local.gcp_project}:${local.gcp_region}:${local.db_instance_name}"
  }
}

resource "k8s_manifest" "app-deployment" {
  count = "${var.module_count}"
  content = "${data.template_file.app-deployment.rendered}"
}
