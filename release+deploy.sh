#!/bin/sh
set -e

if [ -z "$1" ]; then 
   echo "A unique version must be passed as an argument, aborting" >&2
fi

app_version="$1"
docker push "benjvi/terraform-cd-example-app:${app_version}"
docker push benjvi/terraform-cd-example-app:latest
pwd
./tf-pkg-build.sh "tf-state-benjvi/terraform-cd-example-app" "${app_version}" "gcs" # todo: repo type should be mandatory + part of id
./tf-pkg-push.sh "tf-state-benjvi/terraform-cd-example-app" "${app_version}" "gcs"
pwd
ls -la
# need to push first because config refers to the module in gcs
cd tf-pkg-tgt
ls -la
terraform init -upgrade
terraform workspace select test
terraform apply -auto-approve -input=false
cd -
