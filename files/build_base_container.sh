#!/bin/bash

NAME_IMAGE="development-container-for-ros-2-humble-on-m1-2-mac-asv_loyola"
echo "Build Base Container"

docker build -f common.dockerfile -t ghcr.io/tomastravis/${NAME_IMAGE}:v22.04 .
docker push ghcr.io/tomastravis/${NAME_IMAGE}:v22.04