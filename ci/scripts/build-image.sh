#!/bin/bash

pushd repo
URL=$(git remote show -n origin | grep Fetch | cut -d: -f2-)
IMAGE=$(basename $URL .git)
VERSION=$(git rev-parse --short HEAD)

jupyter-repo2docker --no-build --debug --user-id 1000 --user-name jovyan --image $IMAGE:$VERSION . 2> dockerfile.tmp
sed -n -e '/FROM/,$p' dockerfile.tmp > Dockerfile
cat Dockerfile
rm dockerfile.tmp
popd

#copy files to output dir build
cp -Ra repo/binder build
cp repo/Dockerfile build
cp repo/main.ipynb build
cp repo/README.md  build
