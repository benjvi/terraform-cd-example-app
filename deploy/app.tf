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

resource "k8s_manifest" "app-service" {
  content = "${file("manifests/app-service.yaml")}"
}

resource "k8s_manifest" "app-deployment" {
  content = "${file("manifests/app-deployment.yaml")}"
}
