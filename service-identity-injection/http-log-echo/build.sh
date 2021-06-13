#!/bin/bash

echo "Build http server..."
docker build -t http-log-echo-builder:latest -f build.dockerfile .
docker container create --name http-log-echo-builder http-log-echo-builder:latest
docker container cp http-log-echo-builder:/opt/server ./http-log-echo-server
docker container rm http-log-echo-builder

echo "Build docker image..."
docker build -t http-log-echo:latest .
