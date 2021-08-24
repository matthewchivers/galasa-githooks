#!/bin/sh

# Get repo directory
# Create links from current directory to repo directory
# Below, Current Dir becomes Galasa-Repo-Dir, and githooks dir becomes this dir (pwd)

GALASA_REPO_DIR=$1
GALASA_REPO_HOOKS_DIR="$GALASA_REPO_DIR/.git/hooks"

GALASA_GIT_REPO_PRESENT=$(ls -rlta $GALSA_REPO_DIR | grep '.git$' | wc -l)

GITHOOKS_DIR="$(pwd)"
GITHOOKS_REPO="${GITHOOKS_DIR##*/}"

get_date() {
    echo $(date +"%m-%d-%y-%T")
}

ARCHIVE_DIR=$GALASA_REPO_DIR/.git/hooks/archives/$(get_date)
archive_file() {
    TO_ARCHIVE=$1
    if [ -e $GALASA_REPO_HOOKS_DIR/$TO_ARCHIVE ]
    then
        [ ! -e $GALASA_REPO_DIR/.git/hooks/archives ] && mkdir $GALASA_REPO_DIR/.git/hooks/archives
        [ ! -e $ARCHIVE_DIR ] && mkdir $ARCHIVE_DIR && echo "Archiving existing pre-commit hooks with timestamp $(get_date)"

        echo "Archiving file $1"
        rsync -a $GALASA_REPO_HOOKS_DIR/$TO_ARCHIVE $ARCHIVE_DIR/$FILE_NAME || { echo "Archiving $TO_ARCHIVE failed" ; exit 1; }
        rm -rf $GALASA_REPO_HOOKS_DIR/$TO_ARCHIVE || { echo "Removing $TO_ARCHIVE failed" ; exit 1; }
    fi
}

make_executable() {
    MKEX_FILE="$GALASA_REPO_HOOKS_DIR/$1"
    if [ -e "$MKEX_FILE" ]
    then
        chmod +x $MKEX_FILE || { echo "Chmod Failed" ; exit 1; }
    fi
}

create_symlink() {
    FILE_FROM=$1
    FILE_TO=$2
    echo "Creating link from $FILE_FROM to $FILE_TO"
    if [ -e "$FILE_FROM" ]
    then
        ln -s $FILE_FROM $FILE_TO || { echo "Symlink Creation Failed" ; exit 1; }
    else 
        echo "ERROR: File does not exist: $FILE_FROM"; exit 1;
    fi
}

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

##############################
#    START OF MAIN SCRIPT    #
##############################

output_title "Archiving Incumbent Hooks / Scripts"

archive_file "commit-msg"
archive_file "pre-commit"
archive_file "prepare-commit-msg"
archive_file "scripts"

output_title "Performing Checks"

# Quickly check whether all the necesary values are present and ready
echo "Checking repositories"
if [ $GALASA_GIT_REPO_PRESENT -ne 1 ]; then echo "You must pass in the path to the galasa repository that needs the githooks"; exit 1; fi
if [ "$GITHOOKS_REPO" != "galasa-githooks" ]; then echo "This setup script needs to be executed within the galasa-githooks directory"; exit 1; fi


# Create a symlink to the githooks scripts directory and the local repo git hooks scripts directory
output_title "Creating symlinks to utility scripts "
create_symlink $GITHOOKS_DIR/scripts $GALASA_REPO_DIR/.git/hooks/scripts
output_title "Making utility scripts executable"
make_executable "scripts/utilities/checkstyle.sh"
make_executable "scripts/utilities/gradle-build.sh"
make_executable "scripts/utilities/wrapper.sh"

# Create a symlink to commit-msg in the local git hooks directory
output_title "Creating commit-msg githook"
create_symlink $GITHOOKS_DIR/hooks/commit-msg $GALASA_REPO_DIR/.git/hooks/commit-msg
make_executable "commit-msg"

# Create a symlink to pre-commit in the local git hooks directory
output_title "Creating pre-commit githook"
create_symlink $GITHOOKS_DIR/hooks/pre-commit $GALASA_REPO_DIR/.git/hooks/pre-commit
make_executable "pre-commit"

# Create a symlink to prepare-commit-msg in the local git hooks directory
output_title "Creating prepare-commit-msg githook"
create_symlink $GITHOOKS_DIR/hooks/prepare-commit-msg $GALASA_REPO_DIR/.git/hooks/prepare-commit-msg
make_executable "prepare-commit-msg"

output_title "Completed setup of git hooks"