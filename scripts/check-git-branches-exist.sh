#!/usr/bin/env sh

# Define installation directories
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

# This shell script should be portable to Linux/macOS

# Requires git (+ ssh authentication)

# Step 1: Check if the branches exist on the remote repository
check_branches() {
    branches="$1"
    for branch in $branches; do
        if git ls-remote --exit-code --heads origin "$branch" > /dev/null; then
            echo "✅ Branch '$branch' exists on the remote."
        else
            echo "❌ Branch '$branch' does not exist on the remote!"
        fi
    done
}

print_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -b, --branches <branches>   Specify branches to check. Pass multiple -b/--branches to check multiple branches."
    echo "                              Example: 'main dev release'"
    echo "  -h, --help                  Show this help message."
    echo "Environment Variables:"
    echo "  BRANCHES                    Specify branches to check (space-separated)."
    echo "                              Overrides command-line arguments."
}

parse_arguments() {
    branches=""
    branches_provided="" # Flag to track if branches were explicitly provided
    while [ "$#" -gt 0 ]; do
        case "$1" in
            -b|--branches)
                shift
                branches="$branches $1"
                branches_provided="true" # Mark that branches were provided
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

    # Only override branches with BRANCHES if no command-line argument was provided
    if [ -z "$branches_provided" ]; then
        # if no -b or --branch was passed
        if [ -n "$BRANCHES" ]; then
            # if env variables was given
            branches="$BRANCHES"
        else
            # if no branches were provided, use default branches
            branches="$DEFAULT_FALLBACK_BRANCHES"
        fi
    fi

    echo "$branches"
}

main() {
    echo "🔧 Checking branches..."  # Updated signal for this level

    # Parse arguments and environment variable
    branches=$(parse_arguments "$@")

    # Check git branches
    check_branches "$branches"
}

# Run the main function or print help
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    print_help
    exit 0
else
    main "$@"
fi
