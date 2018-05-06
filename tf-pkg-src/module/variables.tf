
variable "module_count" {
  type = "string"
}

variable "app_version" {
  type = "string"
}

variable "app_profile" {
  type = "string"
}

variable "namespace" {
  type = "string"
}

locals {
  db_instance_name = "terraform-cd-example-app-${var.namespace}-1" //gcp db instance names cannot be reused for up to a week
  gcp_region = "europe-west2"
  gcp_project = "parabolic-rope-822"
  cloudflare_domain = "bjv.me"
}

