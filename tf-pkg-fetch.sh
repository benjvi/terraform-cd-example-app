#!/bin/bash

# fetches the package from the local repository and installs it in the build tgt folder under the current working directory, ready for terraform apply
# TODO: should also handle fetch from remote repository

package_repo="$HOME/.tf-pkg"
build_tgt_dir="tf-pkg-tgt"

package_id=${1?"Package id must be specified as first arg (must be unique within repo)"}
package_version=${2?"Package version must be specified as second arg"}

# package uri is a path, but it should also support gcs/s3 storage
package_uri="${package_repo}/${package_id}/${package_version}"


if [ -e "${package_uri}" ]; then
    mkdir -p "${build_tgt_dir}"
    rm -rf "${build_tgt_dir}"/*.tf* "${build_tgt_dir}/module"
    cp -r "${package_uri}"/ ${build_tgt_dir}/
else
    echo "Package not found"
fi

