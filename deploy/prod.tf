
module "app-prod" {
  # source = "git@github.com:benjvi/example-app-tf-module.git?ref=v1" 
  source = "github.com/benjvi/example-app-tf-module" 
  module_count = "${terraform.workspace == "prod" ? "1" : "0"}"
  cloudflare_domain = "${var.cloudflare_domain}"
  app_version = "39"
}
