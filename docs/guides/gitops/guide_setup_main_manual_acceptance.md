---
tags:
  - how-to
  - guide
---

# Protect `main` Branch, with Manual QA

This is a `how-to` Guide, with everything you need, to "protect" your  
`main` branch with **Manual Checks**.  
The Guide is part of the `release-me` *Phase 2* **Git Ops Process**.

## Prerequisites
- a `github repository`
- account with permission to **Repository Settings**

## Guide

[//]: # (Go to 'Repositoty Settings' --> 'Branch Rules')

<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    .image-container {
        display: inline-block;
        vertical-align: middle;
        line-height: 1.5; /* Adjust this value to match your text line height */
    }

    .image-container img {
        height: 1.5em; /* Adjust this value to match your text line height */
        border: 1px solid #ddd;
        border-radius: 4px;
        padding: 2px; /* Reduced padding to fit better with text */
        vertical-align: middle;
    }
  </style>
  </head>
</html>


1. Navigate to <span class="image-container"><img src="../github-repo-settings-button.png" alt="Repository Settings"></span> in your `Repository Settings` on github.com

    ![Github Repo Navigation](github-repo-navigation.png)

2. Click `branches` under `Code and Automation`

    ![Code and Automation -> Branches](github-repos-settings-branches.png)

3. If no `Rule` exists that matches the `main` name pattern, create one


3. If PR is NOT required before merging, enable the rule to allow code merges in `main` **only via PR**

    [//]: # (Require PR)
    ![alt text](require-pr-before-merging.png)

4. Require Manual Approval, using self `code review`

    ![Required review from code owners](require-review-from-code-owners.png)


## Congratulations!

You should now have ensured no merge happens to `main` branch, without manual intervention!
