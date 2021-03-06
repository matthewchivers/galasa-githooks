REPO_DIR=$1
PROJ_DIR=$2

HOOK_DIR="$REPO_DIR/.git/hooks"
SCRI_DIR="$HOOK_DIR/scripts"
UTIL_DIR="$SCRI_DIR/utilities"
CONF_DIR="$SCRI_DIR/configurations"

if [ $REPO_DIR = ""]; then exit 1; fi
if [ $PROJ_DIR = ""]; then exit 1; fi

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

# Generate a [hopefully unique] name for our stash
GIT_STASH_NAME="unstaged-changes-$(head /dev/urandom | LC_ALL=C tr -dc A-Za-z0-9 | head -c10 ; echo '')"

apply_stash() {
    output_title "Retrieving stashed changes."
    # Get stash number that has our unique stash name
    STASH_NUMBER="$(git stash list | grep -E "$GIT_STASH_NAME$" | head -n1 | awk -F: '{print $1;}')"
    git stash apply -q $STASH_NUMBER
}

# Ensure we will apply the stash even if failing for some reason
trap apply_stash EXIT

# Stash unstaged changes to prevent building/linting against files not being included in the commit
output_title "Stashing current changes (ensuring we work on only staged files)."
git stash push -k -m $GIT_STASH_NAME

# Check style
output_title "Performing Linting"
$UTIL_DIR/checkstyle.sh $CONF_DIR || { echo "Style Checks Failed" ; exit 1; }

# Run a gradle build against the project directory
output_title "Performing Build"
$UTIL_DIR/gradle-build.sh $PROJ_DIR || { echo "Gradle Build Failed" ; exit 1; }
