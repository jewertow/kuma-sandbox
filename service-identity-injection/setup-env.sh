#!/bin/bash

echo "Cleanup..."
if [ -d "kuma" ]; then
  rm -rf kuma
fi
if [ -d "bin" ]; then
  rm -rf bin
fi

git clone https://github.com/jewertow/kuma.git
cd kuma
git checkout feat/service-identity-injection-x-kuma-headers
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
