#!/bin/sh

############################## Variable Declarations ##############################

GIT_BASE_DIR="vd-tool"
JAR_CLASSPATH_PATTERN="$GIT_BASE_DIR/tools/base/vector-drawable-tool/build/libs/*"
JAVA_OBJ_DIR="obj"
JAVA_RELEASE_VER="21" # Defaults to Java 21.X
JAVA_SOURCE_PATH="wrapper/main/com/staticcodes/vdwrapper/Wrapper.java"
PROJECT_ROOT="../../.." # The relative path back to the project root directory
VD_TOOL_EXTACTED_LIB_DIR="$GIT_BASE_DIR/lib/"
VD_TOOL_ZIP_DIST_PATH="../$GIT_BASE_DIR/tools/base/vector-drawable-tool/build/distributions/vd-tool.zip"
VD_WRAPPER_BUILD_DIR="." # Uses the current working directory of the executed script.
VD_WRAPPER_CLASS_PATH="$PROJECT_ROOT/obj/com/staticcodes/vdwrapper/Wrapper.class"
VD_WRAPPER_DIR_STRUCT="com/staticcodes/vdwrapper/"
VD_WRAPPER_JAR_FILE="vd-tool-wrapper.jar"
VD_WRAPPER_JAR_PATH="$PROJECT_ROOT/$VD_WRAPPER_JAR_FILE"
VD_WRAPPER_MAIN_CLASS="com.staticcodes.vdwrapper.Wrapper"
VD_WRAPPER_REPO_LINK="https://github.com/Static-Codes/vd-tool"
VD_WRAPPER_WORKSPACE="tmp"


############################## Function Declarations ##############################

# Assembling the distribution of vd-tool
ASSEMBLE_DIST_FOR_VD_TOOL() { ./gradlew assembleDist; }


# Navigating back to the project root directory.
BACK_OUT_TO_PROJECT_ROOT() { cd $PROJECT_ROOT; }

# Cleaning the workspace to prevent unexpected behavior due to cached build files.
CLEAN_WORKSPACE() { rm -rf "$VD_WRAPPER_WORKSPACE" && mkdir "$VD_WRAPPER_WORKSPACE"; }

CLONE_VD_TOOL_REPO() { git clone $VD_WRAPPER_REPO_LINK; }

COMPILE_WRAPPER() { 
    cd ../ && 
    javac -d "$JAVA_OBJ_DIR" \
          --release "$JAVA_RELEASE_VER" \
          -classpath "$JAR_CLASSPATH_PATTERN" "$JAVA_SOURCE_PATH"; 
}

# Copying the Wrapper.class file to the wrapper's innermost directory.
COPY_CLASSFILE_TO_WRAPPER_DIR() { cp "$VD_WRAPPER_CLASS_PATH" "$VD_WRAPPER_DIR_STRUCT"; }

# Creating the directory structure for the wrapper.
CREATE_WRAPPER_DIR_STRUCT() { mkdir -p "$VD_WRAPPER_DIR_STRUCT"; }

# Deleting the workspace once compilation has completed.
DELETE_WORKSPACE() { BACK_OUT_TO_PROJECT_ROOT && rm -rf "$VD_WRAPPER_WORKSPACE"; }

# Fetching the maven and vd-tool sources.
FETCH_SOURCES_FOR_VD_TOOL() { ./gradlew fetchSources; }

# Flattening all nested dependency jars then deleting the original artifacts.    
FLATTEN_DEPENDENCIES() { for f in *.jar; do jar xf "$f" && rm "$f"; done }

# Navigating to the extracted Java library directory in the workspace.
GO_TO_EXTRACTED_LIB_DIR() { cd "$VD_TOOL_EXTACTED_LIB_DIR"; }

# Navigating to the vd-tool root directory.
GO_TO_VD_TOOL_ROOT() { cd $GIT_BASE_DIR; }


# Navigating to the build workspace for the wrapper.
GO_TO_WRAPPER_WORKSPACE () { cd "$VD_WRAPPER_WORKSPACE"; }

# Packaging VDWrapper in $VD_WRAPPER_BUILD_DIR
PACKAGE_WRAPPER() { jar cfe "$VD_WRAPPER_JAR_PATH" "$VD_WRAPPER_MAIN_CLASS" "$VD_WRAPPER_BUILD_DIR"; }

# Stripping external cryptographic sigs to avoid SecurityExceptions
STRIP_CRYPTOGRAPHIC_SIGS() { rm -f META-INF/*.SF META-INF/*.RSA META-INF/*.DSA; } 

# Unzipping the vd-tool distribution zip archive.
UNZIP_DISTRIBUTION_ZIP() { unzip -qq "$VD_TOOL_ZIP_DIST_PATH"; } 



############################## Build Workflow ##############################


echo "Cloning vd-tool from $VD_WRAPPER_REPO_LINK..."
# git clone $VD_WRAPPER_REPO_LINK
if [ ! -d $GIT_BASE_DIR ]; then
    CLONE_VD_TOOL_REPO || { echo "Failed to clone the repository, please try again." && return; }
    sleep 1
else
    printf "%b\n"
    echo "A repository for vd-tool has already been located in the current directory."
    echo "Skipping clone."
    printf "%b\n"
fi

echo "Navigating to the local repository..." && printf "%b\n"
# cd "vd-tool"
GO_TO_VD_TOOL_ROOT || { echo "Failed to navigate to the local repository" && return; }

echo "Fetching build resources for vd-tool..."
# ./gradlew fetchSources
FETCH_SOURCES_FOR_VD_TOOL || { echo "Failed to fetch build resources for vd-tool" && return; }
sleep 1

echo "Assembling the latest distributions for vd-tool..."
# ./gradlew assembleDist
ASSEMBLE_DIST_FOR_VD_TOOL || { echo "Failed to assemble the latest distributions for vd-tool" && return; }
sleep 1


echo "Compiling $VD_WRAPPER_JAR_FILE..."
# javac -d obj --release 21 -classpath "vd-tool/tools/base/vector-drawable-tool/build/libs/*" wrapper/main/com/staticcodes/vdwrapper/*.java
COMPILE_WRAPPER || { echo "Failed to compile $VD_WRAPPER_JAR_FILE" && return; }
sleep 1

echo "Cleaning workspace..."
# rm -rf $VD_WRAPPER_WORKSPACE && mkdir $VD_WRAPPER_WORKSPACE && cd $VD_WRAPPER_WORKSPACE
CLEAN_WORKSPACE || { echo "Failed to clean the build workspace." && return; }

echo "Navigating to the cleaned workspace..."
GO_TO_WRAPPER_WORKSPACE || { echo "Failed to navigate to the cleaned workspace." && return; }
sleep 1

echo "Unzipping the latest vd-tool distribution zip archive..."
# unzip "$VD_TOOL_ZIP_DIST_PATH"
UNZIP_DISTRIBUTION_ZIP || { echo "Failed to unzip the distribution archive." && return; }
sleep 1

echo "Navigating to the extracted dependency directory for vd-tool"
# cd "$VD_TOOL_EXTACTED_LIB_DIR"
GO_TO_EXTRACTED_LIB_DIR || { echo "Failed to navigate to the extracted dependency directory." && return; }
sleep 1

echo "Flattening dependencies from the newly extracted archive..."
# for f in *.jar; do jar xf "$f" && rm "$f"; done
FLATTEN_DEPENDENCIES || { echo "Failed to flatten dependencies." && return; }
sleep 1

echo "Stripping cryptographic signatures from dependency manifests..."
# rm -f META-INF/*.SF META-INF/*.RSA META-INF/*.DSA
STRIP_CRYPTOGRAPHIC_SIGS || { echo "Failed to strip cryptographic signature." && return; }
sleep 1

echo "Creating the wrapper's directory structure..."
# mkdir -p "$VD_WRAPPER_DIR_STRUCT"
CREATE_WRAPPER_DIR_STRUCT || { echo "Failed to create the wrapper's directory structure." && return; }
sleep 1

echo "Copying the wrapper's class file to the directory created above..."
# cp "$VD_WRAPPER_CLASS_PATH" "$VD_WRAPPER_DIR_STRUCT"
COPY_CLASSFILE_TO_WRAPPER_DIR || { echo "Failed to copy the wrappers class file." && return; }
sleep 1

echo "Packaging the wrapper..."
# jar cfe "$FINAL_WRAPPER_PATH" "$VD_WRAPPER_MAIN_CLASS" "$VD_WRAPPER_BUILD_DIR"
PACKAGE_WRAPPER || { echo "Failed to package the wrapper." && return; }
sleep 1
echo "Successfully packaged wrapper -> vdwrapper.jar"

echo "Deleting temporary workspace now that compilation has completed."
# cd ../../../ && rm -rf $VD_WRAPPER_WORKSPACE
DELETE_WORKSPACE || { echo "An error occured when deleting the temporary workspace." && return; }
echo "Deleted workspace!"
sleep 0.3
echo "Execution complete!"