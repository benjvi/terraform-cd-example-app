#!/bin/bash
# TODO validate args arent empty
# this command builds the package from src and puts it in the tgt dir, ready for terraform apply
# it also places the package in the local repository, ready for push to a remote store

# TODO: add command for scaffolding module in the correct format - 'tf-package init'
workspaces=( "default" "test" "prod" )

local_repo="$HOME/.tf-pkg"
pkg_src_dir="tf-pkg-src"
build_tgt_dir="tf-pkg-tgt"

package_id=${1?"Package id must be specified as first arg (must be unique within repo)"}
package_version=${2?"Package version must be specified as second arg"}
package_repo=${3:-"local"}

# package uri is a path, but it should also support gcs/s3 storage
local_package_uri="${local_repo}/${package_id}/${package_version}"

# ensure repo and folder for package revisions exists
mkdir -p "${local_repo}/${package_id}"
# intended to fail if package version already exists
mkdir "${local_package_uri}" || (echo "Package version already exists, aborting" >&2 && exit 1)

# copy file providers.tf to tf-package directory
# why - putting providers in modules gets messy so not dealing with it for now
# this is where we inject credentials, better for consumer to specify this
# depending on providers used, explicit providers block may not be required
if [ -e "${pkg_src_dir}/providers.tf" ]; then
    cp "${pkg_src_dir}/providers.tf" "${local_package_uri}/"
fi

# prod could use separate config or just not be present
# this is optional
if [ -e "${pkg_src_dir}/prod.tf" ]; then
    cp "${pkg_src_dir}/prod.tf" "${local_package_uri}/" 
fi

# module must be present, can't have a package that is empty
cp -r "${pkg_src_dir}/module" "${local_package_uri}/module"

# TODO: looks like this causes some error??
read -r -d '' version_variable <<EOF
variable "app_version" {
  type = "string"
  default = "${package_version}"
}
EOF

printf "${version_variable}\n\n" > "${local_package_uri}/main.tf"

# generate workspaces based on a standard tf config that consumes a module with a version and a module count
# nb profile can be used to set app profiles or different config in a module in a new environment
# it *is not* used to determine namespacing of deployments - this relies directly on the workspace (for now)
for space in "${workspaces[@]}"; do
    read -r -d '' module <<EOF
module "app_${space}" {
  source = "./module"  
  module_count = "\${terraform.workspace == "${space}" ? "1" : "0"}"
  app_version = "\${var.app_version}"
  app_profile = "\${terraform.workspace}"
  namespace = "\${terraform.workspace}"
}
EOF
   printf "${module}\n\n" >> "${local_package_uri}/main.tf"
done
# add some metadata to the packagge
read -r -d '' pkginfo <<EOF
{
    "package_id": "${package_id}",
    "package_version": "${package_version}",
    "package_repo": "${package_repo}"
}
EOF
printf "${pkginfo}\n" > "${local_package_uri}/.pkg-info.json"
 
# what to do with local state?? (initially going to disallow it)
mkdir -p "${build_tgt_dir}"
rm -rf "${build_tgt_dir}"/*.tf* "${build_tgt_dir}/module"
echo "${local_package_uri}"
ls -la "${local_package_uri}"
cp -r "${local_package_uri}"/* ${build_tgt_dir}/

