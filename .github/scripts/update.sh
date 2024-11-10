#!/usr/bin/env bash

radarr() {
  radarr_url="https://radarr.servarr.com/v1/update/master/changes?runtime=netcore&os=linux"
  local new_version="$(curl -sSL "${radarr_url}" | jq '.[0].version' -r)"

  if [ "${new_version}" ]; then
    sed -i "s/radarr_version=.*/radarr_version=${new_version}/" radarr/Dockerfile
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

sonarr() {
  sonarr_url="https://services.sonarr.tv/v1/releases"
  sonarr_channel="v4-stable"
  local new_version=$(curl -sSL ${sonarr_url} | jq -r "first(.[] | select(.releasechannel==\"${sonarr_channel}\") | .version)")

  if [ "${new_version}" ]; then
    sed -i "s/sonarr_version=.*/sonarr_version=${new_version}/" sonarr/Dockerfile
  fi

  if output=$(git status --porcelain) && [ -z "$output" ]; then
    # working directory clean
    echo "no new sonarr version available!"
  else
    # uncommitted changes
    git commit -a -m "updated sonarr to version: ${new_version}"
    git push
  fi
}

prowlarr() {
  prowlarr_url="https://prowlarr.servarr.com/v1/update/master/changes?os=linux&runtime=netcore"
  local new_version="$(curl -sSL "${prowlarr_url}" | jq '.[0].version' -r)"

  if [ "${new_version}" ]; then
    sed -i "s/PROWLARR_VERSION=.*/PROWLARR_VERSION=${new_version}/" prowlarr/Dockerfile
  fi

  if output=$(git status --porcelain) && [ -z "$output" ]; then
    # working directory clean
    echo "no new prowlarr version available!"
  else
    # uncommitted changes
    git commit -a -m "updated prowlarr to version: ${new_version}"
    git push
  fi
}

qbittorrent() {
  qbittorrent_url="https://api.github.com/repos/qbittorrent/qBittorrent/tags"
  local new_version="$(curl -SsL ${qbittorrent_url} | jq -r -c '.[] | .name' | grep -iv 'rc\|beta\|alpha' | head -n 1)"

  if [ "${new_version}" ]; then
    sed -i "s/QBT_VERSION=.*/QBT_VERSION=${new_version}/" qbittorrent/Dockerfile
  fi

  if output=$(git status --porcelain) && [ -z "$output" ]; then
    # working directory clean
    echo "no new qbittorrent version available!"
  else
    # uncommitted changes
    git commit -a -m "updated qbittorrent to version: ${new_version}"
    git push
  fi
}
radarr
sonarr
prowlarr
qbittorrent
