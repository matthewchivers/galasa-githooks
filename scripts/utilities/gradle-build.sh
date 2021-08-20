#!/bin/sh
echo "PERFORMING A GRADLE BUILD"

sleep 2

# Use program argument as project dirctory
PROJ_DIR=$1

echo "Using project directory (argument): $PROJ_DIR"

# Move into the project directory
cd $PROJ_DIR

# Stash unstaged changes
# > Working directory might be different from staging area.
# > Stashing before build means we check staged files for errors, not working files.
git stash -q --keep-index


# Perform gradle build
gradle build
RESULT=$?

# Unstash 
git stash pop -q

# Move back out of the project directory to the last directory
cd -

# Abort Commit
if [ $RESULT -ne 0 ]
then
    echo "GRADLE BUILD FAILED. ABORTING COMMIT"
    exit 1;
fi




