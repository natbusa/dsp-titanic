#!/bin/bash

pushd repo
URL=$(git remote show -n origin | grep Fetch | cut -d: -f2-)
IMAGE=$(basename $URL .git)
VERSION=$(git rev-parse --short HEAD)

jupyter-repo2docker --no-build --debug --user-id 1000 --user-name jovyan --image $IMAGE:$VERSION . 2> dockerfile.tmp
sed -n -e '/FROM/,$p' dockerfile.tmp > ../Dockerfile
rm dockerfile.tmp
popd

#copy files to output dir build/src
cp -Ra repo build/src

# copy/move build packs and Dockerfiles
R2D_PATH=/usr/local/lib/python3.6/site-packages/repo2docker
cp -Ra $R2D_PATH/buildpacks/conda build
cp -Ra $R2D_PATH/buildpacks/python build
mv Dockerfile build/

# debug
cat build/Dockerfile
ls -Rla build
