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


