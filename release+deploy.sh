#!/bin/sh

if [ -n "$1" ]; then 
    docker push "benjvi/terraform-cd-example-app:$1"
    TF_ARGS="-var \"app_version=$1\""
fi
docker push benjvi/terraform-cd-example-app:latest

cd deploy
terraform init -upgrade
terraform workspace select test
terraform apply -auto-approve -input=false $TF_ARGS
cd -
