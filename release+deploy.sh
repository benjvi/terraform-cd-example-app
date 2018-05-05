#!/bin/sh
set -e

if [ -z "$1" ]; then 
   echo "A unique version must be passed as an argument, aborting" >&2
fi

app_version="$1"
docker push "benjvi/terraform-cd-example-app:${app_version}"
docker push benjvi/terraform-cd-example-app:latest

./tf-pkg-build.sh "tf-state-benjvi/terraform-cd-example-app" "${app_version}" "gcs"
./tf-pkg-push.sh "tf-state-benjvi/terraform-cd-example-app" "${app_version}" "gcs"

# could push package after if we were running acceptance tests here
cd tf-pkg-tgt
terraform init -upgrade
terraform workspace select test
terraform apply -auto-approve -input=false
cd -
