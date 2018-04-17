provider "google" {
  credentials = "${file("$HOME/API Project-20f67b6e6d86.json")}"
  project     = "parabolic-rope-822"
  region      = "eu-west2"
}

variable "cloudflare_email" {
  type = "string"
  default = "ben881@gmail.com"
}

variable "cloudflare_token" {
  type = "string"
}

variable "cloudflare_domain" {
  type = "string"
  default = "bjv.me"
}

variable "app_module_version" {
  type = "string"
  default = "master"
}

provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

terraform {
  backend "gcs" {
    bucket  = "tf-state-benjvi"
    prefix  = "terraform/state/snap-app"
  }
}


# module sources dont support interpolation yet, even when using registry
module "app-test" {
  source = "https://github.com:benjvi/example-app-tf-module.git" 
  module_count = "${terraform.workspace == "test" ? "1" : "0"}"
  cloudflare_domain = "${var.cloudflare_domain}"
  app_version = "latest"
}

module "app-prod" {
  source = "git@github.com:benjvi/example-app-tf-module.git?ref=v1" 
  module_count = "${terraform.workspace == "prod" ? "1" : "0"}"
  cloudflare_domain = "${var.cloudflare_domain}"
}
