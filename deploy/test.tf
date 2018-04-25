
# module sources dont support interpolation yet, even when using registry
module "app-test" {
  source = "./tf-package-52" 
  module_count = "${terraform.workspace == "test" ? "1" : "0"}"
}

