REPO_DIR=$1
PROJ_DIR=$2

HOOK_DIR="$REPO_DIR/.git/hooks"
SCRI_DIR="$HOOK_DIR/scripts"
UTIL_DIR="$SCRI_DIR/utilities"
CONF_DIR="$SCRI_DIR/configurations"

if [ "$REPO_DIR" = ""]; then exit 1; fi
if [ "$PROJ_DIR" = ""]; then exit 1; fi

# Generate a [hopefully unique] name for our stash
GIT_STASH_NAME="unstaged-changes-$(head /dev/urandom | LC_ALL=C tr -dc A-Za-z0-9 | head -c10 ; echo '')"

apply_stash() {
    # Get stash number that has our unique stash name
    STASH_NUMBER="$(git stash list | grep -E "$GIT_STASH_NAME$" | head -n1 | awk -F: '{print $1;}')"
    git stash apply $STASH_NUMBER
}

# Ensure we will apply the stash even if failing for some reason
trap apply_stash EXIT

# Stash unstaged changes to prevent building/linting against files not being included in the commit
git stash push -m $GIT_STASH_NAME

# Check style
$UTIL_DIR/checkstyle.sh $CONF_DIR || { echo "Style Checks Failed" ; exit 1; }

# Run a gradle build against the project directory
$UTIL_DIR/gradle-build.sh $PROJ_DIR || { echo "Gradle Build Failed" ; exit 1; }
