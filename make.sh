#!/bin/sh

GRAAL_VM_JDK_FILE="graalvm-jdk-21_linux-x64_bin.tar.gz"

GRAAL_VM_JDK_NATIVE_IMAGE_BINARY=""
GRAAL_VM_JDK_PARENT_DIR=""

GRAAL_VM_JDK_URL="https://download.oracle.com/graalvm/21/latest/$GRAAL_VM_JDK_FILE"
OUTPUT_DIR="bin/"
VD_WRAPPER_MAIN_CLASS="com.staticcodes.vdwrapper.Wrapper"
CURL_BINARY="/usr/bin/curl"
FIND_BINARY="/usr/bin/find"
WGET_BINARY="/usr/bin/wget"


WGET=false
CURL=false

if [ ! -f $FIND_BINARY ]; then { echo "Please install find to continue." && return; }
elif [ -f "$CURL_BINARY" ]; then CURL="true"
elif [ -f "$WGET_BINARY" ]; then WGET="true" 
fi

if [ $WGET = "false" ] && [ $CURL = "false" ]; then { echo "Please install curl or wget to continue." && return; }
elif [ $CURL = "true" ]; then $CURL_BINARY $GRAAL_VM_JDK_URL -o $GRAAL_VM_JDK_FILE
elif [ $WGET = "true" ]; then $WGET_BINARY $GRAAL_VM_JDK_URL -o $GRAAL_VM_JDK_FILE
fi


tar -zxf $GRAAL_VM_JDK_FILE || { echo "Unable to extract the graalvm jdk tarbell" && return; }
rm $GRAAL_VM_JDK_FILE || { echo "Unable to remove $GRAAL_VM_JDK_FILE" && return; }

GRAAL_VM_JDK_PARENT_DIR=$(find . -name graalvm-jdk-21.* | head -n 1) || { 
    echo "Unable to locate the extracted graalvmjdk directory" && return;
}

GRAAL_VM_JDK_NATIVE_IMAGE_BINARY="$GRAAL_VM_JDK_PARENT_DIR/bin/native-image"

mkdir $OUTPUT_DIR || { echo "Unable to create output directory for the compiled executable" && return; }
$GRAAL_VM_JDK_NATIVE_IMAGE_BINARY \
    -jar vd-tool-wrapper.jar \
    -o $OUTPUT_DIR/vdtool-wrapper \
    --no-fallback \
    --enable-url-protocols=http,https \
    --initialize-at-build-time=com.google.common.jimfs.SystemJimfsFileSystemProvider