#!/bin/sh

GIT_DIR_PRESENT=$(ls -rlta | grep '.git$' | wc -l)
CURRENT_DIR="$(pwd)"
REPO="${CURRENT_DIR##*/}"
GITHOOKS_DIR=$1
GITHOOKS_REPO="${GITHOOKS_DIR##*/}"

if [ $GIT_DIR_PRESENT -ne 1 ]
then
    echo "This setup script needs to be executed in the root repo directory";
    exit 1;
fi

if [ "$REPO" = "galasa-githooks" ]
then
    echo "This setup script needs to be executed in a galasa repository";
    exit 1;
fi

if [ "$GITHOOKS_REPO" != "galasa-githooks" ]
then
    echo "You must pass in the path to the galasa-githooks repository";
    exit 1;
fi

ln -s $GITHOOKS_DIR/scripts $CURRENT_DIR/.git/hooks/scripts || { echo "Symlink Creation Failed" ; exit 1; }
chmod +x $CURRENT_DIR/.git/hooks/scripts/utilities/checkstyle.sh || { echo "Chmod Failed" ; exit 1; }
chmod +x $CURRENT_DIR/.git/hooks/scripts/utilities/gradle-build.sh || { echo "Chmod Failed" ; exit 1; }
chmod +x $CURRENT_DIR/.git/hooks/scripts/utilities/wrapper.sh || { echo "Chmod Failed" ; exit 1; }

ln $GITHOOKS_DIR/hooks/commit-msg $CURRENT_DIR/.git/hooks/commit-msg || { echo "Symlink Creation Failed" ; exit 1; }
chmod +x $CURRENT_DIR/.git/hooks/commit-msg || { echo "Chmod Failed" ; exit 1; }

ln $GITHOOKS_DIR/hooks/pre-commit $CURRENT_DIR/.git/hooks/pre-commit || { echo "Symlink Creation Failed" ; exit 1; }
chmod +x $CURRENT_DIR/.git/hooks/pre-commit || { echo "Chmod Failed" ; exit 1; }

ln $GITHOOKS_DIR/hooks/prepare-commit-msg $CURRENT_DIR/.git/hooks/prepare-commit-msg || { echo "Symlink Creation Failed" ; exit 1; }
chmod +x $CURRENT_DIR/.git/hooks/prepare-commit-msg || { echo "Chmod Failed" ; exit 1; }

