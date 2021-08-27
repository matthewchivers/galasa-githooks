#!/bin/sh

CONF_DIR=$1

output_title() {
    echo ""
    STRING_TO_PRINT=$1
    STRING_LENGTH=$(expr ${#STRING_TO_PRINT} + 4)
    ST_TO_PR=$(printf "%-${STRING_LENGTH}s" "*")
    echo "${ST_TO_PR// /*}"
    echo "* $STRING_TO_PRINT *"
    echo "${ST_TO_PR// /*}"
    echo ""
}

output_title "Linting Using Checkstyle"

for file in $(git diff --diff-filter=d --cached --name-only | grep -E "\.java")
do 
    echo "Checking file: $file"
    java -jar $CHECKSTYLE_JAR -c $CONF_DIR/java_checks.xml $file
    if [ $? -ne 0 ] 
    then
        echo "Checkstyle failed on staged file: '$file'. Please check your code and try again."
        exit 1
    fi
done

