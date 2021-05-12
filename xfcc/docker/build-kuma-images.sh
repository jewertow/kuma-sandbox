#!/bin/bash

echo "Building Kuma CP..."
docker build -t kuma-cp-sandbox:latest -f kuma-cp.dockerfile ..

echo "Building Kuma DP..."
docker build -t kuma-dp-sandbox:latest -f kuma-dp.dockerfile ..

echo "Building Kuma CTL..."
docker build -t kumactl-sandbox:latest -f kumactl.dockerfile ..

