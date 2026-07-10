#!/bin/sh

chmod +x build.sh || { echo "Failed to give build.sh executable permissions." && return; }
./build.sh || { echo "Failed to build the vd-tool JAR." && return; }

chmod +x make.sh || { echo "Failed to give make.sh executable permissions." && return; }
./make.sh || { echo "Failed to compile the vd-tool-wrapper binary." && return; }