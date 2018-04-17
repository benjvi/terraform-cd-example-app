#!/bin/sh

if [ -n "$TF_VAR_app_version" ]; then 
    docker push "benjvi/terraform-cd-example-app:$1"
fi
docker push benjvi/terraform-cd-example-app:latest

cd deploy
terraform init -upgrade
terraform workspace select test
terraform apply -auto-approve -input=false
cd -
