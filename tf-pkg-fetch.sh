#!/bin/bash

# fetches the package from the local repository and installs it in the build tgt folder under the current working directory, ready for terraform apply
# TODO: check gsutil commands 

local_repo="$HOME/.tf-pkg"
build_tgt_dir="tf-pkg-tgt"

package_id=${1?"Package id must be specified as first arg (must be unique within repo)"}
package_version=${2?"Package version must be specified as second arg"}
package_repo=${3:-"local"}

# package uri is a path, but it should also support gcs/s3 storage
local_package_uri="${local_repo}/${package_id}/${package_version}"


if [ -e "${local_package_uri}" ]; then
    mkdir -p "${build_tgt_dir}"
    rm -rf "${build_tgt_dir}"/*.tf* "${build_tgt_dir}/module"
    cp -r "${local_package_uri}"/ ${build_tgt_dir}/
else
    if [ "${package_repo}" == "gcs" ]; then
        gsutil cp -r "gs://${package_id}/${package_version}" "${local_package_uri}"
    else
        echo "Package not found" >&2 
        exit 1
    fi
    mkdir -p "${build_tgt_dir}"
    rm -rf "${build_tgt_dir}"/*.tf* "${build_tgt_dir}/module"
    cp -r "${local_package_uri}"/ ${build_tgt_dir}/
fi

