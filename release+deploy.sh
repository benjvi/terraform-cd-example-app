#!/bin/sh

if [ -z "$1" ]; then 
   echo "A unique version must be passed as an argument, aborting" >&2
fi

app_version="$1"
docker push "benjvi/terraform-cd-example-app:${app_version}"
docker push benjvi/terraform-cd-example-app:latest
./tf-pkg-build.sh "tfstate-benjvi/terraform-cd-example-app" "${app_version}" "gcs" # todo: repo type should be mandatory + part of id
./tf-pkg-push.sh "tfstate-benjvi/terraform-cd-example-app" "${app_version}" "gcs"
# need to push first because config refers to the module in gcs
cd tf-pkg-tgt
terraform init -upgrade
terraform workspace select test
terraform apply -auto-approve -input=false
cd -
./tf-pkg-push.sh "tfstate-benjvi/terraform-cd-example-app" "${app_version}" "gcs" 
