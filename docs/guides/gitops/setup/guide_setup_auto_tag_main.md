---
tags:
  - how-to
  - guide
---

# Automatically `Tag Commit` on `main`, after PR merge

This guide shows you how to include `Automatic Tagging on main` with **Semantic Version** tag, in your `Release Me` **Git Ops Process**.

## Prerequisites
- a `github repository`
- account with permission to **Repository Settings**

## Guide

To **automatically tag** the commit on `main/master` branch, after **Code Merge** from `release` branch, via a PR bearing the `auto-deploy` label, follow below steps.

### 1. Create a Workflow, that when Triggered creates a Git Tag

Populate file `.github/workflows/gitops-tag-main.yml` with content:
{% raw %}
```yaml
on:
  pull_request:
    types: [closed]
    branches:
      - main
      - master
jobs:
  tag_main:
    # if code merged to 'main/master' br, via PR from 'release' br bearing the 'auto-deploy' label
    if: github.event.pull_request.merged == true &&
      github.event.pull_request.head.ref == 'release' &&
      contains(github.event.pull_request.labels.*.name, 'auto-deploy')
    uses: boromir674/automated-workflows/.github/workflows/go-tag-main.yml@18b20a331650752492a8ed614feb4057216b6547  # v1.12.0
    with:
      gh_username: ${{ vars.TAG_USER_NAME }}
      gh_email: ${{ vars.TAG_USER_EMAIL }}
      main_branch: ${{ github.event.pull_request.base.ref }}
    secrets:
      # needs Content write to create Tag!
      # needs Actions write to allow other workflows to listen to tag event!
      GH_PAT_ACTION_RW: ${{ secrets.GH_TOKEN_CONTENT_ACTIONS_RW }}
```
{% endraw %}
to create a Github Action Workflow that can **automatically tag** the commit on `main/master` branch and triggers only when **Code Merges** to `main/master` from `release` branch via a PR that must bear the `auto-deploy` label.

 [//]: # (This is a comment)

### 2. Grant required Permissions to create remote Git Tags

  1. Generate a **PAT**, scoped for your repository, bearing the `read/write` permission for:
     - *Contents*
     - *Actions*
  2. Make PAT available to your repo as a `Repository Secret`
     1. Create **Repository Secret** with **name** `GH_TOKEN_CONTENT_ACTIONS_RW`
     2. Set the `GH_TOKEN_CONTENT_ACTIONS_RW` **Repository Secret Value** to the generated **PAT**

## Congratulations :partying_face:

Now, you should have **automated** the **Publishing of Tag**, when running your `Release Me` **Git Ops Process**!
