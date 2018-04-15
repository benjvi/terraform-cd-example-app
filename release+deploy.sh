#!/bin/sh
# see GH issue kubernetes/kubernetes #30617o
cp .terraformrc "$HOME/.terraformrc"
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/API Project-20f67b6e6d86.json"
docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"
#docker push benjvi/terraform-cd-example-app:${TRAVIS_BUILD_NUMBER}

gcloud version
cd deploy
gcloud version
gsutil cp gs://tf-state-benjvi/terraform/state/snap-app/default.tfstate .
rm default.tfstate
terraform init
terraform apply -auto-approve -input=false
cd -
