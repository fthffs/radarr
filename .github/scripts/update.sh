#!/usr/bin/env bash

radarr() {
  radarr_url="https://radarr.servarr.com/v1/update/master/changes?runtime=netcore&os=linux"
  local new_version="$(curl -sSL "${radarr_url}" | jq '.[0].version' -r)"

  if [ "${new_version}" ]; then
    sed -i "s/RADARR_VERSION=.*/RADARR_VERSION=${new_version}/" Dockerfile
  fi

  if output=$(git status --porcelain) && [ -z "$output" ]; then
    # working directory clean
    echo "no new radarr version available!"
  else
    # uncommitted changes
    git commit -a -m "updated radarr to version: ${new_version}"
    git push
  fi
}

radarr
