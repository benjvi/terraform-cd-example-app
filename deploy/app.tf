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

data "terraform_remote_state" "kubernetes" {
  backend = "gcs"
  config {
    bucket  = "tf-state-benjvi"
    prefix  = "terraform/state/kubernetes"  
  }
}

# make sure the kubernetes resources get created in the right cluster
# not intended to make sure kubectl is setup + with correct credentials in all cases
resource "null_resource" "set_cluster" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials \"${data.terraform_remote_state.kubernetes.cluster_name}\" --zone \"${data.terraform_remote_state.kubernetes.cluster_zone}\""
  }
}

resource "k8s_manifest" "app-service" {
  content = "${file("manifests/app-service.yaml")}"
  depends_on = ["null_resource.set_cluster"]
}

resource "k8s_manifest" "app-deployment" {
  content = "${file("manifests/app-deployment.yaml")}"
  depends_on = ["null_resource.set_cluster"]
}
