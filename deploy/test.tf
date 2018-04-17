
# module sources dont support interpolation yet, even when using registry
module "app-test" {
  source = "github.com/benjvi/example-app-tf-module" 
  module_count = "${terraform.workspace == "test" ? "1" : "0"}"
  cloudflare_domain = "${var.cloudflare_domain}"
  app_version = "${var.app_version}"
}

