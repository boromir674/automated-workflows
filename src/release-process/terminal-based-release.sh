#!/usr/bin/env sh

# Requires executables: git, code, gh, uv, sed

# RUN THIS, WHEN All changes for Release are ALREADY on the Integration_Br branch

# USAGE
# ./terminal-based-release.sh <NEW_VERSION> [<INTEGRATION_BRANCH>] [--skip-semver] [--skip-changelog]
# Example:
# ./terminal-based-release.sh 0.1.0
# ./terminal-based-release.sh 0.1.0 dev --skip-semver
# ./terminal-based-release.sh 0.1.0 dev --skip-changelog


### Terminal-Based Release Process ###

# Topic_A, Topic_B, ... , Topic_N
#    \         |            /
#     \        |           /
#       \      |         /
#         \    |       /
#         Integration_Br
#              |
#          Release_Br
#              |
#          Default_Br


# Define installation directories
BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/check-git-and-protection"

# Try to source shared environment variables, fallback to defaults if unavailable
if [ -f "${CONFIG_DIR}/git_env.sh" ]; then
    . "${CONFIG_DIR}/git_env.sh"
else
    MAIN_BRANCH="${MAIN_BRANCH:-main}"
    RELEASE_BRANCH="${RELEASE_BRANCH:-release}"
    DEV_BRANCH="${DEV_BRANCH:-dev}"
fi

### 1. SEM VER SOURCE UPDATE ###
# Files to update with new version number
# SOURCES_TO_UPDATE="${SOURCES_TO_UPDATE:-src/my_package/__init__.py pyproject.toml uv.lock README.md}"

### 2. CHANGELOG Update ###
CHANGELOG_FILE="${CHANGELOG_FILE:-CHANGELOG.md}"


# Use shared or fallback variables for branch configuration
# See Guide: https://automated-workflows.readthedocs.io/guide_setup_terminal_based_release_process/
DEFAULT_BRANCH="${DEFAULT_BRANCH:-$MAIN_BRANCH}"
INTEGRATION_BRANCH="${INTEGRATION_BRANCH:-$DEV_BRANCH}"
RELEASE_BRANCH="$RELEASE_BRANCH"


set -e

# Parse flags
SKIP_SEMVER=false
SKIP_CHANGELOG=false

NEW_VERSION=""
BRANCH_WITH_CHANGES=""

while [ $# -gt 0 ]; do
    case $1 in
        --skip-semver)
            SKIP_SEMVER=true
            ;;
        --skip-changelog)
            SKIP_CHANGELOG=true
            ;;
        *)
            if [ -z "$NEW_VERSION" ]; then
                NEW_VERSION=$1
            elif [ -z "$BRANCH_WITH_CHANGES" ]; then
                BRANCH_WITH_CHANGES=$1
            fi
            ;;
    esac
    shift
done

if [ -z "$NEW_VERSION" ]; then
    echo "Usage: $0 <NEW_VERSION> [<BRANCH_WITH_CHANGES>] [--skip-semver] [--skip-changelog]"
    exit 1
fi

BRANCH_WITH_CHANGES=${BRANCH_WITH_CHANGES:-$INTEGRATION_BRANCH}

# Check if the script is run from the root of the repository
if [ ! -d ".git" ]; then
    echo "This script must be run from the root of the repository."
    exit 1
fi
# Check if the user is in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "This script must be run inside a git repository."
    exit 1
fi

### MAIN SCRIPT ###

git l | head -n 10
echo "========================="
git branch -vv
echo

echo "We are about to checkout ${BRANCH_WITH_CHANGES} branch and pull latest changes!"
echo "Make sure all changes for release are already merged into ${BRANCH_WITH_CHANGES}!"
echo

echo "Press any key to continue.. (unless ctrl + C)"
read dummy

git checkout "${BRANCH_WITH_CHANGES}"
# git pull

# Initialize internal step counter
STEP_NUMBER=1

# Check if the user opted to skip the semantic version update step
if [ "$SKIP_SEMVER" = false ]; then
    ## 1. SEM VER SOURCE UPDATE ##
    echo
    # Print dynamic step number for semantic version update
    echo " STEP ${STEP_NUMBER} ---> Automatic Sem Ver Bump in sources"
    echo
    # Sem Ver Major Minor Patch + Pre-release metadata
    regex="[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*)?"

    set -e

    ## 1.a Update PYPROJECT - Sem Ver
    # Until uv migration is verified we must update all regex matches (ie for poetry and uv config sections!)
    PYPROJECT='pyproject.toml'
    sed -i.bak -E "s/(version = ['\"])[0-9]+\.[0-9]+\.[0-9]+(['\"])/\\1${NEW_VERSION}\\2/" "${PYPROJECT}" && rm "${PYPROJECT}.bak"

    ## 2.b Update README.md - Sem Ver
    README_MD='README.md'
    # sed -i -E "s/(['\"]?v?)[0-9]+\.[0-9]+\.[0-9]+(['\"]?)/\1${VERSION}\2/" "${README_MD}"

    # 2.b.1 Replace occurrences such as /v2.5.8/ with /v2.5.9/, excluding lines with `image_tag:`
    sed -i -E "/image_tag:/!s/(['\"]?v?)${regex}(['\"]?)/\1${NEW_VERSION}\2/" "${README_MD}"

    # 2.b.2 Replace occurrences such as /v2.5.8..main with /v2.5.9..main, excluding lines with `image_tag:`
    sed -i -E "/image_tag:/!s/(['\"]?v?)${regex}\.\./\1${NEW_VERSION}../" "${README_MD}"

    # 2.c - Optional
    # if project is managed by poetry, we are ok
    # if project is managed by uv, we need to update the Package sem ver in the lock
    if [ -f "uv.lock" ]; then
        echo "Updating uv.lock with new version ${NEW_VERSION}"
        # Update the version in uv.lock
        uv lock
    fi

    echo "Automatic Sem Ver Bump completed!"
    git diff --stat
    echo
    echo ' --> Please check the DIFF'
    echo 'Press enter to continue or Ctrl+C to abort...'
    read -r dummy

    git diff

    echo
    echo ' --> Please make any manual modifications/fixes, if needed'
    echo 'Press enter to continue or Ctrl+C to abort...'
    read -r dummy

    echo ' --> Now the Sem Ver updates should be GOOD!'
    echo 'Press enter to continue or Ctrl+C to abort...'
    read -r dummy

    git add -u

    echo =======
    git status -uno
    echo =======
    git diff --cached
    echo =======
    git diff --stat --cached
    echo =======

    # Press any key to continue dialog
    echo "Press any key to commit version changes!"
    read dummy

    ### 1.d Commit the changes
    git commit -m "chore: bump version to ${NEW_VERSION}"

    # Increment internal step number after completing semantic version update
    STEP_NUMBER=$((STEP_NUMBER + 1))
fi

# Check if the user opted to skip the changelog update step
if [ "$SKIP_CHANGELOG" = false ]; then
    ## 2. CHANGELOG Update ##
    echo
    # Print dynamic step number for changelog update
    echo " STEP ${STEP_NUMBER} ---> Auto-Update CHANGELOG"
    echo

    # Generate changelog entry using group-commits.sh
    changelog_entry=$(${BIN_DIR}/group-commits.sh --prev "${DEFAULT_BRANCH}")

    # using sed proved troublesome (needed to escape special characters), now using simpler heuristic
    # insert new entry after 5th line of CHANGELOG.md file!

    # Create a temporary file for the updated changelog
    temp_file=$(mktemp)

    ## 2.a Construct new CHANGELOG.md file
    # Read the first 5 lines and write them to the temp file
    head -n 6 "${CHANGELOG_FILE}" > "${temp_file}"


    # 2.a.1 Append the new changelog entry
    echo "\n## ${NEW_VERSION} ($(date +%Y-%m-%d))\n" >> "${temp_file}"
    echo "### Changes\n" >> "${temp_file}"

    echo "${changelog_entry}" >> "${temp_file}"

    # 2.a.2 Append the rest of the original changelog file, skipping the first 5 lines
    tail -n +6 "${CHANGELOG_FILE}" >> "${temp_file}"

    # Replace the original changelog file with the updated one
    mv "${temp_file}" "${CHANGELOG_FILE}"


    # Display the updated changelog
    echo "Updated CHANGELOG:"
    echo "=================="
    # cat "${CHANGELOG_FILE}"

    # Pause for manual edits
    echo "Press any key to open '${CHANGELOG_FILE}' in VS Code for manual edits!"
    read dummy
    code "${CHANGELOG_FILE}"

    echo "Press any key after done editing '${CHANGELOG_FILE}'"
    read dummy

    git add "${CHANGELOG_FILE}"
    echo =======
    git diff --stat --cached
    echo =======

    # Dialog before Commit
    echo "Press any key to commit '${CHANGELOG_FILE}'!"
    read dummy

    ### 2.b Commit the changes
    git commit -m "docs(changelog): add ${NEW_VERSION} Release entry in ${CHANGELOG_FILE}"

    # Increment internal step number after completing changelog update
    STEP_NUMBER=$((STEP_NUMBER + 1))
fi

echo
# Print completion message
echo "DONE!"

echo
echo "Press any key to push changes to ${BRANCH_WITH_CHANGES} remote!"
read dummy

## 3. PUSH Integration_Br TO REMOTE
git push


## 4. OPEN PR TO RELEASE BRANCH
git checkout ${RELEASE_BRANCH}
git rebase ${DEFAULT_BRANCH}
git push
# git checkout "${BRANCH_WITH_CHANGES}"
gh pr create --base ${RELEASE_BRANCH} --head "${BRANCH_WITH_CHANGES}" --title "Release ${NEW_VERSION}" --body "This PR contains version bump and changelog updates for version ${NEW_VERSION}"


## 5. ENABLE AUTO MERGE with 'merge' strategy (others are 'squash' and 'rebase')
# this cmd can sometimes fail, so we retry up to 3 times
set +e
gh pr merge "${BRANCH_WITH_CHANGES}" --merge --auto
if [ $? -ne 0 ]; then
    echo "gh pr merge ${BRANCH_WITH_CHANGES} --merge --auto failed, retrying..."
    for i in {1..3}; do
        gh pr merge "${BRANCH_WITH_CHANGES}" --merge --auto
        if [ $? -eq 0 ]; then
            break
        fi
    done
fi
set -e


## 6. WATCH GITHUB ACTIONS WORKFLOWS RUNNING
echo "========== Watch GH Workflow Run =========="
gh run watch

echo "========================="
echo "DONE! PR ${BRANCH_WITH_CHANGES} --> ${RELEASE_BRANCH} Merged!"

echo
echo "Press any key to update local '${RELEASE_BRANCH}' branch from remote!"
read dummy


## 7. CREATE PR TO DEFAULT_BRANCH (ie release --> main)
git checkout ${RELEASE_BRANCH}
git pull
gh pr create --base ${DEFAULT_BRANCH} --head "${RELEASE_BRANCH}" --title "Release ${NEW_VERSION} to production" --body "This PR delivers version ${NEW_VERSION} to production"
echo
echo "Press any key to make a RELEASE CANDIDATE tag!"
read dummy

## 8. CREATE and PUSH RC TAG
RC_TAG="v${NEW_VERSION}-rc"

git tag -f "$RC_TAG"
git push origin -f "$RC_TAG"

echo
echo "Release Candidate Pipeline Triggered!"


# press any key to continue
echo "Please run 'gh run watch' to watch the CI/CD Pipeline (press any key to continue)"
read dummy

# TODO: try to implement the below; currently after gh run watch finishes it stops execution of the sshell script!
echo "Please watch the CI/CD Pipeline to succeed (press any key to continue to 'live watch')!"
read dummy
# gh run watch

## 9. PROMPT USER TO MERGE the PR if QA/CHECKS PASSED
echo "========================="
echo "Assuming CI/CD Pipeline Succeeded!"

echo "[NEXT] Please run the below to complete merge to '${DEFAULT_BRANCH}'"
echo
echo "gh pr merge --subject \"[NEW] Automated Workflows v${NEW_VERSION}\" --body \"Release v${NEW_VERSION}\" --merge"

echo "[IF] prohibited, you can use --admin flag:"
echo
echo "gh pr merge --admin --subject \"[NEW] Automated Workflows v${NEW_VERSION}\" --body \"Release v${NEW_VERSION}\" --merge"

echo
# press any key to continue
echo "After Merge to '${DEFAULT_BRANCH}' branch is made (ie via CLI or github.com), press any key to proceed with updating local '${DEFAULT_BRANCH}' branch"
read dummy

echo "========================="

git checkout ${DEFAULT_BRANCH}
git pull

## 10. CREATE & PUSH Production Sem Ver TAG
git tag -f "v${NEW_VERSION}"
git push origin -f "v${NEW_VERSION}"
echo
echo "Release v${NEW_VERSION} is now tagged!"
echo

# press any key to continue
echo "Please watch the CI/CD Pipeline to succeed (press any key to continue to 'live watch')!"
read dummy

## 11. WATCH GITHUB ACTIONS WORKFLOWS RUNNING
gh run watch

## 12. Conclude with SUCCESS MESSAGE
echo
echo "========================="
echo "Tag v${NEW_VERSION} is now pushed to remote!"
echo
echo " [FINISH] :-)"
