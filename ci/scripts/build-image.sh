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

R2D_PATH=/usr/local/lib/python3.6/site-packages/repo2docker
cp -Ra $R2D_PATH/buildpacks/conda build
cp -Ra $R2D_PATH/buildpacks/python build

# src directory is required when building even if empty
mkdir -p build/buildpacks/src

ls -la build
