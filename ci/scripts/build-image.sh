#!/bin/bash

URL=$(git remote show -n origin | grep Fetch | cut -d: -f2-)
IMAGE=$(basename $URL .git)
VERSION=$(git rev-parse --short HEAD)

CMD="repo2docker --no-run --debug --user-id 1000 --user-name jovyan --image $IMAGE:$VERSION ${URL%.git}"

echo $CMD
#docker run -v /var/run/docker.sock:/var/run/docker.sock jupyter/repo2docker:8a5b1ef $CMD
