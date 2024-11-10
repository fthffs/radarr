#!/usr/bin/env bash

radarr() {
  RADARR_URL="https://radarr.servarr.com/v1/update/master/changes?runtime=netcore&os=linux"

  NEW_VERSION="$(curl -sSL ${RADARR_URL} | jq '.[0].version' -r)"

  if [ "${NEW_VERSION}" ]; then
    sed -i "s/RADARR_VERSION=.*/RADARR_VERSION=${NEW_VERSION}/" radarr/Dockerfile
  fi

  if output=$(git status --porcelain) && [ -z "$output" ]; then
    # Working directory clean
    echo "No new Radarr version available!"
  else
    # Uncommitted changes
    git commit -a -m "Updated Radarr to version: ${NEW_VERSION}"
    git push
  fi
}

radarr
