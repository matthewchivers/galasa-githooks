#!/bin/sh

# Use program argument as project dirctory
PROJ_DIR=$1

# Move into the project directory
cd $PROJ_DIR

# Perform gradle build
gradle build
RESULT=$?

# Back out of the project directory to the last directory
cd -

# Abort Commit
if [ $RESULT -ne 0 ]
then
    echo "GRADLE BUILD FAILED. ABORTING COMMIT"
    exit 1;
fi
