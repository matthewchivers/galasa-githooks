#!/bin/sh

CONF_DIR=$1

for file in $(git diff --diff-filter=d --cached --name-only)
do 
    echo "File: $file"
    java -jar $CHECKSTYLE_JAR -c $CONF_DIR/java_checks.xml $file
    if [ $? -ne 0 ] 
    then
        echo "Checkstyle failed on staged file: '$file'. Please check your code and try again."
        exit 1
    fi
done

