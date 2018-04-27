#!/bin/bash
# TODO: validate arrgs aren't empty
# TODO: check gsutil commands

local_repo="$HOME/.tf-pkg"
package_id=${1?"Package id must be specified as first arg (must be unique within repo)"}
package_version=${2?"Package version must be specified as second arg"}

local_package_uri="${local_repo}/${package_id}/${package_version}"

if [ -e "${local_package_uri}" ]; then
  package_repo=$(cat "${local_package_uri}/.pkg-info.json" | jq -r ".package_repo")
  if [ "${package_repo}" == "gcs" ]; then
    echo "pushing to gcs"
    gsutil cp -r "${local_package_uri}" "gs://${package_id}/${package_version}"
  else
    echo "Unsupported repo type for pushing (gcs only)"
  fi
fi
