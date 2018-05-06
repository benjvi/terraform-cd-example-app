provider "google" {
  credentials = "${file("~/API-Project-20f67b6e6d86.json")}"
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


