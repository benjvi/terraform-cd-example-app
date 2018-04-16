provider "google" {
  credentials = "${file("$HOME/API Project-20f67b6e6d86.json")}"
  project     = "parabolic-rope-822"
  region      = "eu-west2"
}

terraform {
  backend "gcs" {
    bucket  = "tf-state-benjvi"
    prefix  = "terraform/state/snap-app"
  }
}

variable "cloudflare_token" {
  type = "string"
}

module "app" {
  source  = "module"
  cloudflare_token = "${var.cloudflare_token}"
}
