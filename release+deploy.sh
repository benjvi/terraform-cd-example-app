#!/bin/sh
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
