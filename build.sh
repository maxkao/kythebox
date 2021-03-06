#!/bin/bash
#
# Name:    build.sh
# Purpose: Build a Docker image for Kythe development.
#
# Copyright (C) 2019 Michael J. Fromberger. All Rights Reserved.
#
# This script assumes you have docker installed on your machine. When invoked,
# this script builds and tags an image that contains all the build tools and
# external dependencies needed to build Kythe with Bazel.
#
set -e -o pipefail

cd "$(dirname $0)"
. config.sh

build_image() {
    local tag="${1:?missing tag}"
    local sfx="$(echo $tag | cut -d/ -f2)"
    docker build -t "$tag" -f image/Dockerfile."$sfx" image
}

case "$1" in
    ("")
	image_exists "$buildtag" || build_image "$buildtag"
	image_exists "$imagetag" || build_image "$imagetag"
	;;
    (all)
	build_image "$buildtag"
	build_image "$imagetag"
	;;
    (push)
	docker push "$buildtag"
	docker push "$imagetag"
	;;
    (*)
	echo "Unknown build command '$1'" 1>&2
	exit 1
	;;
esac
