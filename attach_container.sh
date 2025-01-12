#!/bin/sh
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
cd $SCRIPT_DIR

cd files

if [ "$(docker ps -al | grep development-container-for-ros-2-humble-on-m1-2-mac_for_${USER}_container-asv_loyola)" ]; then
    ./launch_container.sh
else
    echo "Please start container first!"
fi
