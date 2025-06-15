#!/bin/sh

# CHECK GITHUB BRANCH PROTECTION AND RULESET for BRANCHES
# Portable POSIX-compliant script to query GitHub branch protection rules and rulesets.


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

# Portable POSIX-compliant script to query GitHub branch protection rules.

# Helper function to show usage instructions
print_help() {
    echo "Usage: $0 -r <repository> [-b <branches>] [-h]"
    echo "Options:"
    echo "  -r <repository>   GitHub repository in 'owner/repo' format (required)."
    echo "  -b <branches>     Space-separated list of branches to check (default: main dev release)."
    echo "  -h                Show this help message."
    echo "Environment Variables:"
    echo "  BRANCHES          Specify branches to check (space-separated). Overrides command-line arguments."
}

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

# Function to parse command-line arguments and environment variables
parse_arguments() {
    branches=""
    branches_provided=""
    REPO="" # Ensure REPO is initialized
    while [ "$#" -gt 0 ]; do
        case "$1" in
            -r)
                shift
                if [ -n "$1" ]; then
                    REPO="$1" # Correctly assign the repository argument
                else
                    echo "Error: Missing value for -r option."
                    exit 1
                fi
                ;;
            -b)
                shift
                if [ -n "$1" ]; then
                    branches="$branches $1"
                    branches_provided="true" # Mark that branches were provided
                else
                    echo "Error: Missing value for -b option."
                    exit 1
                fi
                ;;
            -h|--help) # Handle both -h and --help
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


    # Validate that REPO is set and in the correct format
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

    # Only override branches with BRANCHES if no command-line argument was provided
    if [ -z "$branches_provided" ]; then
        if [ -n "$BRANCHES" ]; then
            branches="$BRANCHES"
        else
            branches="$DEFAULT_FALLBACK_BRANCHES"
        fi
    fi

    # Output both branches and REPO as a single result
    echo "$branches|$REPO"
}

query_branch_protection() {
    local repo_uri="$1"
    local branch="$2"

    echo
    echo "🔒 Checking Branch Protection Rules"
    echo "Repository: $repo_uri"
    echo "========================================"

    # Fetch protection rules for the branch
    protection_data=$(gh api "/repos/${repo_uri}/branches/${branch}/protection" \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        --jq '. | {required_status_checks: .required_status_checks, required_pull_request_reviews: .required_pull_request_reviews, required_conversation_resolution: .required_conversation_resolution, message: .message}' 2>/dev/null)

    # Ensure the output is valid JSON
    if ! echo "$protection_data" | jq empty >/dev/null 2>&1; then
        echo "Error: Invalid JSON response for branch '${branch}'."
        return 1
    fi

    # Check if the branch is not protected (HTTP 404)
    if echo "$protection_data" | jq -e '.message == "Branch not protected"' --raw-output >/dev/null 2>&1; then
        echo "[Warning]: Ensure branch '${branch}' is included in a Ruleset, because there were no Protection Rules found."
        return 0
    fi

    # Extract relevant fields using jq
    strict=$(echo "$protection_data" | jq -r '.required_status_checks.strict // "false"')
    contexts=$(echo "$protection_data" | jq -r '.required_status_checks.contexts[]? // empty')
    dismiss_stale_reviews=$(echo "$protection_data" | jq -r '.required_pull_request_reviews.dismiss_stale_reviews // "false"')
    require_code_owner_reviews=$(echo "$protection_data" | jq -r '.required_pull_request_reviews.require_code_owner_reviews // "false"')
    required_approving_review_count=$(echo "$protection_data" | jq -r '.required_pull_request_reviews.required_approving_review_count // 0')
    required_conversation_resolution=$(echo "$protection_data" | jq -r '.required_conversation_resolution.enabled // "false"')

    echo "Attributes:"
    echo "  - 🔄 Strict status checks: $strict"
    echo "  - 📋 Required contexts (aka Checks):"
    echo "$contexts"
    echo "  - 🗑️ Dismiss stale reviews: $dismiss_stale_reviews"
    echo "  - 👥 Require code owner reviews: $require_code_owner_reviews"
    echo "  - 📝 Required approving review count: $required_approving_review_count"
    echo "  - 💬 Require conversation resolution: $required_conversation_resolution"
    echo "----------------------------------------"

    # Validate expected values
    if [ "$strict" != "true" ]; then
        echo "⚠️ Warning: Strict status checks are not enabled for branch: $branch"
    else
        echo "✅ OK: Strict status checks are satisfied for branch: $branch"
    fi

    if [ "$dismiss_stale_reviews" != "true" ]; then
        echo "⚠️ Warning: Dismiss stale reviews is not enabled for branch: $branch"
    else
        echo "✅ OK: Dismiss stale reviews are satisfied for branch: $branch"
    fi

    if [ "$require_code_owner_reviews" != "true" ]; then
        echo "⚠️ Warning: Code owner reviews are not required for branch: $branch"
    else
        echo "✅ OK: Code owner reviews are satisfied for branch: $branch"
    fi

    if ! [ "$required_approving_review_count" -ge 1 ] 2>/dev/null; then
        echo "⚠️ Warning: Less than 1 approving review is required for branch: $branch"
    else
        echo "✅ OK: Approving review count is satisfied for branch: $branch"
    fi

    if [ "$required_conversation_resolution" != "true" ]; then
        echo "⚠️ Warning: Conversation resolution is not required for branch: $branch"
    else
        echo "✅ OK: Conversation resolution is satisfied for branch: $branch"
    fi
}

## QUERY RULESET ##
query_ruleset() {
    local repo_uri="$1"
    local branch="$2"

    echo
    echo "📜 Checking Ruleset"
    echo "Repository: $repo_uri"
    echo "========================================"

    # Fetch ruleset for the branch
    ruleset_data=$(gh api "/repos/${repo_uri}/rules/branches/${branch}" \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" 2>/dev/null)

    # Ensure the output is valid JSON and not empty
    if ! echo "$ruleset_data" | jq empty >/dev/null 2>&1; then
        echo "Error: Invalid JSON response for branch '${branch}'."
        return 1
    fi

    if [ "$(echo "$ruleset_data" | jq -r '. | length')" -eq 0 ]; then
        echo "[Warning]: No ruleset found for branch '${branch}'."
        return 0
    fi

    # Process the ruleset data
    ruleset_data=$(echo "$ruleset_data" | jq '[.[] | select(.type == "pull_request" or .type == "required_status_checks")] | reduce .[] as $item ({}; .[$item.type] = $item | del(.[$item.type].type))')

    # Extract relevant fields using jq
    required_approving_review_count=$(echo "$ruleset_data" | jq -r '.pull_request.parameters.required_approving_review_count // 0')
    dismiss_stale_reviews_on_push=$(echo "$ruleset_data" | jq -r '.pull_request.parameters.dismiss_stale_reviews_on_push // "false"')
    require_code_owner_review=$(echo "$ruleset_data" | jq -r '.pull_request.parameters.require_code_owner_review // "false"')
    required_status_checks=$(echo "$ruleset_data" | jq -r '.required_status_checks.parameters.required_status_checks[] | "    - \(.context)" // empty')

    echo "Ruleset Attributes:"
    echo "  - 📝 Required approving review count: $required_approving_review_count"
    echo "  - 🗑️ Dismiss stale reviews on push: $dismiss_stale_reviews_on_push"
    echo "  - 👥 Require code owner review: $require_code_owner_review"
    echo "  - 📋 Required status checks:"
    echo "$required_status_checks"
    echo "----------------------------------------"

    # Validate expected values
    if ! [ "$required_approving_review_count" -ge 1 ] 2>/dev/null; then
        echo "⚠️ Warning: Less than 1 approving review is required for branch: $branch"
    else
        echo "✅ OK: Approving review count is satisfied for branch: $branch"
    fi

    if [ "$dismiss_stale_reviews_on_push" != "true" ]; then
        echo "⚠️ Warning: Dismiss stale reviews on push is not enabled for branch: $branch"
    else
        echo "✅ OK: Dismiss stale reviews on push are satisfied for branch: $branch"
    fi

    if [ "$require_code_owner_review" != "true" ]; then
        echo "⚠️ Warning: Code owner reviews are not required for branch: $branch"
    else
        echo "✅ OK: Code owner reviews are satisfied for branch: $branch"
    fi

    if [ -z "$required_status_checks" ]; then
        echo "⚠️ Warning: No required status checks are defined for branch: $branch"
    else
        echo "✅ OK: Required status checks are satisfied for branch: $branch"
    fi
}

### MAIN FUNCTION ###
main() {
    echo "🚀 Starting Branch Protection Check"
    echo "========================================"

    # Parse arguments and environment variable
    parse_result=$(parse_arguments "$@")
    branches=$(echo "$parse_result" | cut -d'|' -f1)
    REPO=$(echo "$parse_result" | cut -d'|' -f2)

    echo "----------------------------------------"

    # Query branch protection rules for all branches
    for branch in $branches; do
        echo
        echo "🔍 Processing branch: $branch"
        echo "----------------------------------------"
        query_branch_protection "$REPO" "$branch"
        query_ruleset "$REPO" "$branch"
    done

    echo "========================================"
    echo "✅ Completed Checks"
    echo "========================================"
}

# Run the main function or print help
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    print_help
    exit 0
else
    main "$@"
fi
