#!/bin/sh

CONF_DIR=$1

echo "Linting Files: "

# Stash unstaged changes
# > Working directory might be different from staging area.
# > Stashing before build means we check staged files for errors, not working files.
git stash -q --keep-index

for file in $(git diff --diff-filter=d --cached --name-only)
do 
    echo "File: $file"
    java -jar $CHECKSTYLE_JAR -c $CONF_DIR/java_checks.xml $file
    if [ $? -ne 0 ] 
    then
        echo "Checkstyle failed on staged file: '$file'. Please check your code and try again."
        # Unstash 
        git stash pop -q
        exit 1
    fi
done

# Unstash 
git stash pop -q
