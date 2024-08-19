---
tags:
  - how-to
  - guide
---

# Automatically `Clean Up` Git Ops Tags

This guide shows you how to add `Automatic Clean Up` of Git Ops tags, in the `Release Me` **Git Ops Process**.

## Prerequisites
- a `github repository`
- account with permission to **Repository Settings**

## Guide

To **automatically delete** all Git Ops **Tags**, such as `release-me` and `auto-prod-*`, after they served their purpose in the `Release Me` **Git Ops Process**, follow the below steps.

`Automatic Clean Up` in the *last phase* of `Release Me` Git Ops Process, follow below steps.

### 1. Create a Workflow, that when Triggered deletes the Git Ops Tags

Populate file `.github/workflows/gitops-delete-tags.yml` with content:
{% raw %}
```yaml
on:
  pull_request:
    types: [closed]
    branches:
      - main
      - master
jobs:
  delete_tags:
    if: github.event.pull_request.merged == true &&
      github.event.pull_request.head.ref == 'release' &&
      contains(github.event.pull_request.labels.*.name, 'auto-deploy')
    uses: boromir674/automated-workflows/.github/workflows/go-delete-tags.yml@18b20a331650752492a8ed614feb4057216b6547  # v1.12.0
    secrets:
      # pass in GITHUB PAT with Repo Content RW permission/access
      GH_PAT_CONTENT_RW: ${{ secrets.GH_TOKEN_CONTENT_RW }}
```
{% endraw %}
to automatically delete all Git Ops tags, such as `release-me` and `auto-prod-*`, when a PR bearing the `auto-deploy` Label, closes with Code Merge, from `release` to `main/master` branch.

 closes with Code Mergeopen **PR to release**, when `release-me` git tag events happen.

[//]: # (This is a comment)

### 2. Grant required Permissions to delete remote Git Tags

  1. Generate a **PAT**, scoped for your repository, bearing the `read/write` permission for:
     - *Contents*
  2. Make PAT available to your repo as a `Repository Secret`
     1. Create **Repository Secret** with **name** `GH_TOKEN_CONTENT_RW`
     2. Set the `GH_TOKEN_CONTENT_RW` **Repository Secret Value** to the generated **PAT**

## Congratulations :partying_face:

Now, you should have **guaranteed** that all Tags serving as Git Events,
**shall be deleted** when running the `Release Me` **Git Ops Process**
