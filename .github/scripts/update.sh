#!/usr/bin/env bash

radarr() {
  radarr_url="https://radarr.servarr.com/v1/update/master/changes?runtime=netcore&os=linux"
  grep 'radarr_version' Dockerfile
  local new_version="$(curl -sSL "${radarr_url}" | jq '.[0].version' -r)"
  echo "Latest version: ${new_version}"

  if [ "${new_version}" ]; then
    sed -i "s/radarr_version=.*/radarr_version=${new_version}/" Dockerfile
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
