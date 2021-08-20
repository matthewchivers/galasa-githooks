REPO_DIR=$1
PROJ_DIR=$2

HOOK_DIR="$REPO_DIR/.git/hooks"
SCRI_DIR="$HOOK_DIR/scripts"
UTIL_DIR="$SCRI_DIR/utilities"
CONF_DIR="$SCRI_DIR/configurations"

# Check style
$UTIL_DIR/checkstyle.sh $CONF_DIR || { echo "Style Checks Failed" ; exit 1; }

# Run a gradle build against the project directory
$UTIL_DIR/gradle-build.sh $PROJ_DIR || { echo "Gradle Build Failed" ; exit 1; }
