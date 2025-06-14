#!/bin/sh

# Portable POSIX-compliant script to query GitHub branch protection rules and rulesets.

print_help() {
    echo "Usage: $0 -r <repository> [-b <branches>] [-h]"
    echo "Options:"
    echo "  -r <repository>   GitHub repository in 'owner/repo' format (required)."
    echo "  -b <branches>     Space-separated list of branches to check (default: main dev release)."
    echo "  -h                Show this help message."
    echo "Environment Variables:"
    echo "  BRANCHES          Specify branches to check (space-separated). Overrides command-line arguments."
}

DEFAULT_FALLBACK_BRANCHES="main dev release" # Default branches if none provided

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
    local repo_uri="$1"  # ie boromir674/automated-workflows
    local branch="$2"

    echo
    echo "🔒 Checking Branch Protection Rules"
    echo "Branch: $branch"
    echo "Repository: $repo_uri"
    echo "========================================"

    # Fetch protection rules for the branch
    # NOTE: this API is able to query for 'settings/branches' (but not the new gh ruleset feature 'settings/rules'
    protection_data=$(gh api "/repos/${repo_uri}/branches/${branch}/protection" \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" 2>&1)

    # Check if the branch is not protected (HTTP 404)
    if echo "$protection_data" | grep -q "Branch not protected"; then
        echo "[Warning]: Ensure branch '${branch}' is included in a Ruleset, because there were no Protection Rules found."
        return 0
    fi

    # Check for other errors
    if echo "$protection_data" | grep -q "HTTP"; then
        echo "Error: Failed to fetch branch protection rules for branch '${branch}'."
        return 1
    fi

    # DEBUG protection_data
    # echo "[DEBUG] Protection data: $protection_data"

    # Extract relevant fields using BusyBox-compatible tools
    strict=$(echo "$protection_data" | grep -o '"strict": *[^,]*' | awk -F: '{print $2}' | tr -d ' ')
    contexts=$(echo "$protection_data" | grep -o '"contexts": *\[[^]]*\]' | sed 's/.*\[//;s/\]//;s/"//g' | tr ',' '\n' | tr -d ' ')
    dismiss_stale_reviews=$(echo "$protection_data" | grep -o '"dismiss_stale_reviews": *[^,]*' | awk -F: '{print $2}' | tr -d ' ')
    require_code_owner_reviews=$(echo "$protection_data" | grep -o '"require_code_owner_reviews": *[^,]*' | awk -F: '{print $2}' | tr -d ' ')
    required_approving_review_count=$(echo "$protection_data" | grep -o '"required_approving_review_count": *[^,]*' | awk -F: '{print $2}' | tr -d ' ' | sed 's/[{}]//g')
    required_conversation_resolution=$(echo "$protection_data" | grep -o '"required_conversation_resolution": *{[^}]*}' | grep -o '"enabled": *[^,]*' | awk -F: '{print $2}' | tr -d ' ' | sed 's/[{}]//g')

    echo "Attributes:"
    echo "  - 🔄 Strict status checks: $strict"
    echo "  - 📋 Required contexts: $contexts"
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

query_ruleset() {
    local repo_uri="$1"  # ie boromir674/automated-workflows
    local branch="$2"

    echo
    echo "📜 Checking Ruleset"
    echo "Branch: $branch"
    echo "Repository: $repo_uri"
    echo "========================================"

    # Fetch ruleset for the branch
    ruleset_data=$(gh api "/repos/${repo_uri}/rules/branches/${branch}" \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" 2>&1)

    # Check for errors
    if echo "$ruleset_data" | grep -q "HTTP"; then
        echo "Error: Failed to fetch ruleset for branch '${branch}'."
        return 1
    fi

    # DEBUG ruleset_data
    # echo "[DEBUG] Ruleset data: $ruleset_data"

    # Extract relevant fields using BusyBox-compatible tools
    required_approving_review_count=$(echo "$ruleset_data" | grep -o '"required_approving_review_count": *[^,]*' | awk -F: '{print $2}' | tr -d ' ')
    dismiss_stale_reviews_on_push=$(echo "$ruleset_data" | grep -o '"dismiss_stale_reviews_on_push": *[^,]*' | awk -F: '{print $2}' | tr -d ' ')
    require_code_owner_review=$(echo "$ruleset_data" | grep -o '"require_code_owner_review": *[^,]*' | awk -F: '{print $2}' | tr -d ' ')
    required_status_checks=$(echo "$ruleset_data" | grep -o '"context": *"[^"]*"' | awk -F: '{print $2}' | tr -d '"')

    echo "Ruleset Attributes:"
    echo "  - 📝 Required approving review count: $required_approving_review_count"
    echo "  - 🗑️ Dismiss stale reviews on push: $dismiss_stale_reviews_on_push"
    echo "  - 👥 Require code owner review: $require_code_owner_review"
    echo "  - 📋 Required status checks: $required_status_checks"
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

main() {
    echo "🚀 Starting Branch Protection and Ruleset Check"
    echo "========================================"

    # Parse arguments and environment variable
    parse_result=$(parse_arguments "$@")
    branches=$(echo "$parse_result" | cut -d'|' -f1)
    REPO=$(echo "$parse_result" | cut -d'|' -f2)

    echo "Repository: $REPO"
    echo "Branches: $branches"
    echo "----------------------------------------"

    # Query branch protection rules and rulesets for all branches
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
