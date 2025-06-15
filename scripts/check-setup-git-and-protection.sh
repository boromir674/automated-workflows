#!/usr/bin/env sh

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

DEFAULT_FALLBACK_BRANCHES="$MAIN_BRANCH $DEV_BRANCH $RELEASE_BRANCH" # Use shared or fallback variables

print_help() {
    echo "Usage: $0 -r <repository> [-b <branches>] [-h]"
    echo "Options:"
    echo "  -r <repository>   GitHub repository in 'owner/repo' format (required)."
    echo "  -b <branches>     Space-separated list of branches to check (default: main dev release)."
    echo "  -h                Show this help message."
    echo "Environment Variables:"
    echo "  BRANCHES          Specify branches to check (space-separated). Overrides command-line arguments."
}

# Check if no arguments are passed
if [ "$#" -eq 0 ]; then
    print_help
    exit 0
fi

# Helper function to derive the repository from git remote
derive_repo_from_git_remote() {
    # Extract the org/repo pattern from `git remote show -v`
    repo=$(git remote -v | grep -oE 'git@github\.com:([^/]+/[^.]+)' | head -n 1 | sed 's/git@github\.com://')
    if [ -z "$repo" ]; then
        echo "Error: Unable to derive repository from git remote."
        exit 1
    fi
    echo "$repo"
}

parse_arguments() {
    branches=""
    branches_provided=""
    REPO="" # Ensure REPO is initialized
    while [ "$#" -gt 0 ]; do
        case "$1" in
            -r|--repo)
                shift
                if [ -n "$1" ]; then
                    REPO="$1"
                fi
                ;;
            -b|--branch)
                shift
                if [ -n "$1" ]; then
                    branches="$branches $1"
                    branches_provided="true"
                fi
                ;;
            -h|--help)
                print_help
                exit 0
                ;;
            *)
                echo "Unknown argument: $1"
                exit 1
                ;;
        esac
        shift
    done

    # Automatically derive REPO if not provided
    if [ -z "$REPO" ]; then
        # echo "🔍 Deriving repository from git remote..."
        REPO=$(derive_repo_from_git_remote)
        # echo "Derived Repository: $REPO"
    fi

    if [ -z "$REPO" ]; then
        echo "Error: Repository (-r) is required."
        print_help
        exit 1
    fi

    if ! echo "$REPO" | grep -qE '^[^/]+/[^/]+$'; then
        echo "Error: Repository format must be 'owner/repo'."
        print_help
        exit 1
    fi

    if [ -z "$branches_provided" ]; then
        if [ -n "$BRANCHES" ]; then
            branches="$BRANCHES"
        else
            branches="$DEFAULT_FALLBACK_BRANCHES"
        fi
    fi

    echo "$branches|$REPO"
}

main() {
    echo "🚀 Starting Git Setup and Protection Check"

    # Parse arguments and environment variable
    parse_result=$(parse_arguments "$@")
    branches=$(echo "$parse_result" | cut -d'|' -f1)
    REPO=$(echo "$parse_result" | cut -d'|' -f2)

    echo "Repository: $REPO"
    echo "Branches: $branches"
    echo "----------------------------------------"

    # Step 1: Check branch existence
    echo "🔧 Step 1: Checking branch existence..."
    branch_flags=""
    for branch in $branches; do
        branch_flags="$branch_flags -b $branch"
    done
    echo "${BIN_DIR}/check-git-branches-exist.sh $branch_flags"
    ${BIN_DIR}/check-git-branches-exist.sh $branch_flags
    echo "----------------------------------------"

    # Step 2: Check branch protection rules
    echo "🔒 Step 2: Checking branch protection rules..."
    if command -v jq >/dev/null 2>&1; then
        echo "✅ jq is installed. Using github_branch_protection.sh..."
        ${BIN_DIR}/check-github-branch-protection-using-jq.sh -r "$REPO" -b "$branches"
    else
        echo "⚠️ jq is not installed. Using no-jq.sh..."
        ${BIN_DIR}/check-github-branch-protection.sh -r "$REPO" -b "$branches"
    fi
    echo "========================================"
    echo "✅ Completed Git Setup and Protection Check"
}

# Run the main function or print help
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    print_help
    exit 0
else
    main "$@"
fi
