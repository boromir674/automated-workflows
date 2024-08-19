#!/usr/bin/env bash

shopt -s nullglob

set -e

# Constants
DOCS_REFS_DIR=docs/api
REF_PAGE_NAME_PREFIX=ref_

# if git binary available
if command -v git &>/dev/null; then
    # capture 'git status -uno' and verify absence of $DOCS_REFS_DIR dir
    git_status_uno=$(git status -uno --porcelain)
    if [[ $git_status_uno == *"$DOCS_REFS_DIR"* ]]; then
        echo "Error: $DOCS_REFS_DIR directory is not empty. Please commit or remove the files."
        exit 1
    fi
fi

chmod +x ./scripts/gen-workflow-ref.py

# Iterate over *.yml and *.yaml files in .github/workflows/

for workflow_yaml in ./.github/workflows/*.yml ./.github/workflows/*.yaml; do
    filename=$(basename $workflow_yaml)
    # exclude if name starts with 'underscore' (_) character
    if [[ $filename == _* ]]; then
        continue
    fi

    # keep only Reusable Workflows that are user-facing (public API)
    # use yq to keep only if there is top-level 'on' key mapping to any object with the 'workflow_call' inner key

    is_user_facing_workflow=$(yq eval 'has("on") and .on | has("workflow_call")' $workflow_yaml)

    if [[ $is_user_facing_workflow == "false" ]]; then
        continue
    fi

    # Generate markdown file for each workflow
    # remove extention from filename (.yml or .yaml)
    markdown_filename="${filename%.*}.md"

    echo "[INFO] Generating Ref Page Markdown: $markdown_filename"

    RELATIVE_FILE_PATH="${DOCS_REFS_DIR}/${REF_PAGE_NAME_PREFIX}${markdown_filename}"
    ./scripts/gen-workflow-ref.py $workflow_yaml >"${RELATIVE_FILE_PATH}"

    # Next update mkdocs.yml nav list's 3rd element, which is an object with key
    # 'References' pointing to a list of objects each with a single mapping of 'title' --> 'url' (str -> str)

    # update mkdocs.yml nav list's 3rd element
    # use yq to append new object to the list of objects in the 3rd element of the nav list
    # if url to be inserted, is not present already

    # get the uri for the markdown file # remove 'docs/' prefix
    # api/ref_go-pr-to-boarding.md
    markdown_file_url="${RELATIVE_FILE_PATH#docs/}"

    # echo "[DEBUG] Markdown file URL: $markdown_file_url"

    # find if markdown file URL is already present in the References list
    # expect object like: {nav: [{...}, {...}, {References: [{"Docker": "api/ref_docker.md"}, {"Github Release": "api/ref_gh_release.md"}]}]

    # yaml equivalent:
    # nav:
    # - Home:
    # - Guides:
    # - References:
    #     # Build, CD
    #     - "Docker": "api/ref_docker.md"
    #     - "Github Release": "api/ref_gh_release.md"

    # V0
    # yq eval '.nav[2].References | .[] | keys | .[] | sub("-","")' mkdocs.yml
    # returns
    # Docker
    # Github Release
    # ...

    # yq '.nav[2].References | to_entries | .[].value | keys | join("")' mkdocs.yml
    # returns
    # Docker
    # Github Release
    # ...

    # V1 storing as it is, splits Github and Release, even though its a single key
    # dynamic_keys=$(yq eval '.nav[2].References | to_entries | .[].value | keys | join("")' mkdocs.yml)

    # V2 pass keys to string processor (available in busybox) to add single-quotes arround each key and then store
    # dynamic_keys=$(yq eval '.nav[2].References | to_entries | .[].value | keys | join(" ")' mkdocs.yml | xargs -n1 | sed "s/.*/'&'/g" | xargs)
    # dynamic_keys=$(yq eval '.nav[2].References | to_entries | .[].value | keys | join("\n")' mkdocs.yml | xargs -n1 | sed "s/.*/'&'/g")

    # yq eval ".nav[2].References | .[] | keys | .[] | sub(\"-\",\"\") | sub(\"^\",\"'\")" mkdocs.yml
    # returns !!
    # 'Docker
    # 'Github Release
    # ...

    # yq eval ".nav[2].References | .[] | keys | .[] | sub(\"-\",\"\") | sub(\"^\",\"'\") | sub(\"\$\",\"'\")" mkdocs.yml
    # returns !!!
    # 'Docker'
    # 'Github Release'
    # ...
    # dynamic_keys=$(yq eval ".nav[2].References | .[] | keys | .[] | sub(\"-\",\"\") | sub(\"^\",\"'\") | sub(\"\$\",\"'\")" mkdocs.yml)

    # dirty_dynamic_keys=$(yq eval ".nav[2].References | .[] | keys | .[] | sub(\"-\",\"\") | sub(\"^\",\"'\") | sub(\"\$\",\"'\")" mkdocs.yml)

    # DRY value, in case Side Navigation Design changes
    API_REFS_KEY="API References"

    dynamic_keys=$(yq eval ".nav[2].[\"${API_REFS_KEY}\"] | .[] | keys | .[] | sub(\"^-\",\"\")" mkdocs.yml)

    # using the keys we can query for the existing URLs to determine if the URL is already present
    file_url_is_present="false"

    IFS=$'\n' # set internal field separator to newline

    # iterate over keys, get URI values and compare with generated URI
    for key in $dynamic_keys; do

        # ie api/ref_docker.md
        uri_in_mkdocs_to_compare=$(yq eval ".nav[2].[\"${API_REFS_KEY}\"] | to_entries | .[].value | select(. | has(\"$key\")) | .[\"$key\"]" mkdocs.yml)

        # it is possible that we get a multiline string with the same values per "row", simply keep the first
        uri_in_mkdocs_to_compare=$(echo "$uri_in_mkdocs_to_compare" | head -n 1)

        echo "[DEBUG] Key: ${key} -> value: (between single-quotes) '${uri_in_mkdocs_to_compare}'"

        # if uri_in_mkdocs_to_compare not emplty string echo debug msg
        if [[ ! -z $uri_in_mkdocs_to_compare ]]; then
            test1=$(test "$uri_in_mkdocs_to_compare" == "\"$markdown_file_url\"" && echo "true" || echo "false")
            test2=$(test "$uri_in_mkdocs_to_compare" == "$markdown_file_url" && echo "true" || echo "false")

            file_url_is_present=false
            if [[ $test1 == "true" || $test2 == "true" ]]; then
                file_url_is_present=true
            fi

            # echo "[DEBUG] Ref Page URL Exists: $file_url_is_present because ${markdown_file_url} == ${uri_in_mkdocs_to_compare}"

            if [[ $file_url_is_present == "true" ]]; then
                # echo "URL ${uri_in_mkdocs_to_compare} already present in mkdocs.yml: $markdown_file_url"
                # echo "Skipping adding entry to Site Navigation"
                # echo
                break
            fi
        fi
    done
    # echo "[DEBUG] File URL is present: $file_url_is_present"
    if [[ $file_url_is_present == "true" ]]; then
        # echo "URL ${uri_in_mkdocs_to_compare} already present in mkdocs.yml: $markdown_file_url"
        # echo "Skipping adding entry to Site Navigation"
        continue
    fi
    echo "[INFO] Adding ${markdown_file_url} to Site Navigation !"
    yq eval ".nav[2].[\"${API_REFS_KEY}\"] += [{\"$filename\": \"$markdown_file_url\"}]" -i mkdocs.yml
done

shopt -u nullglob
