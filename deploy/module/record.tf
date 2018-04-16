resource "cloudflare_record" "webapp" {
  domain = "bjv.me"
  name   = "webapp.${terraform.workspace}"
  value  = "${kubernetes_service.app-service.load_balancer_ingress.0.ip}"
  type   = "A"
  ttl    = 120
}
