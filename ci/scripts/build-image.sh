#!/bin/bash

URL=$(git remote show -n origin | grep Fetch | cut -d: -f2-)
IMAGE=$(basename $URL .git)
VERSION=$(git rev-parse --short HEAD)

jupyter-repo2docker --no-run --no-build --debug --user-id 1000 --user-name jovyan --image $IMAGE:$VERSION . 2> dockerfile.tmp
sed -n -e '/FROM/,$p' dockerfile.tmp > Dockerfile
rm dockerfile.tmp
