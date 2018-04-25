#!/bin/sh

if [ -z "$1" ]; then 
   echo "A unique version must be passed as an argument, aborting" >&2
fi

app_version="$1"
docker push "benjvi/terraform-cd-example-app:${app_version}"
docker push benjvi/terraform-cd-example-app:latest
./tf-pkg-build.sh "benjvi-terraform-cd-example-app" "${app_version}" # todo: add repo type here
cd tf-pkg-tgt
terraform init -upgrade
terraform workspace select test
terraform apply -auto-approve -input=false
cd -
# push once we know the terraform config is valid
#./tf-pkg-push.sh "benjvi-terraform-cd-example-app" "${app_version}" # todo: implement this
