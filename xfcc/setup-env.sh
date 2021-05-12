#!/bin/bash

git clone https://github.com/jewertow/kuma.git
cd kuma
git checkout feat/service-identity-injection
# apply simple workaround that allows to build Kuma in alpine container
git apply ../mk.dev.diff
cd ..

# build Kuma in docker container
docker build -t kuma-builder:latest -f kuma-build.dockerfile .
docker container create --name kuma-builder kuma-builder:latest
docker container cp kuma-builder:/opt/build/artifacts-linux-amd64 bin
docker container rm kuma-builder

# build http server that logs received headers
cd http-log-echo
bash build.sh
cd ..

cd docker
bash build-kuma-images.sh
docker-compose up
