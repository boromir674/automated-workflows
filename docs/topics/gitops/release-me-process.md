# `release-me` - Git Ops Process

This document describes our definition of the **`release-me`** Git Ops Process.

> **release-me** process ships changes in the `head` branch into Production.

It is designed to suit `starting state` as below

{% include 'diagram-release-me-starting-git-state.md' %}

## Phases - Git Flow

The **release-me** process is implemented in 2 Phases.  
Developer fires 2 `git tag` events, one per Phase, to start it, on-demand.

```mermaid
graph LR;
  A[User Branch]
  A --PR --> B[Release]
  B--PR --> C[Main]
```

> **`Phase 1` -> Push the `release-me` git tag to remote**

> **`Phase 2` -> Push a `auto-prod-<sem_ver>` git tag to remote**


A typical **Release** `User Journey` for a single-Developer/Contributor project, might look like 

    {% include 'diagram-user-journey-release-me.md' %}


## Phase 1

**On-demand trigger** by pushing the `release-me` git tag to remote.

```
export tt='release-me'
git tag -d "$tt"; git push --delete origin "$tt"
git tag "$tt" && git push origin "$tt"
```

1. Open `PR` 'User Br' --> 'release', and merge if *PR OK*
2. Open `PR` 'release' --> 'main'

```mermaid

    %%{init: { 'logLevel': 'debug', 'theme': 'gitGraph': {'rotateCommitLabel': true, 'showBranches': true, 'showCommitLabel':true, 'mainBranchName': 'main / master'}} }%%
        gitGraph
            commit id: "[NEW] 1.1.0" type: HIGHLIGHT tag: "v1.1.0"
            commit id: "[FIX] 1.1.1" type: HIGHLIGHT tag: "v1.1.1"
            commit id: "[DEV] 1.1.2-dev" type: HIGHLIGHT tag: "v1.1.2-dev"
            commit id: "[NEW] 1.2.0" type: HIGHLIGHT tag: "v1.2.0"
            commit id: "[NEW] 2.0.0" type: HIGHLIGHT tag: "v2.0.0"
            branch release

            branch "User Br"
            commit
            commit id: "new feat"

            checkout release
            merge "User Br" id: "Merge" type: HIGHLIGHT
```

## Phase 2

**On-demand trigger** by pushing a `auto-prod-<sem_ver>` git tag to remote.

Example:
```
export tt='auto-prod-2.1.0'
git tag -d "$tt"; git push --delete origin "$tt"
git tag "$tt" && git push origin "$tt"
```

1. Auto Merge `PR` 'release' --> 'main', and merge if *PR OK*

```mermaid
    %%{init: { 'logLevel': 'debug', 'theme': 'gitGraph': {'rotateCommitLabel': false, 'showBranches': true, 'showCommitLabel':true, 'mainBranchName': 'main / master'}} }%%
        gitGraph
            commit id: "[NEW] 1.1.0" type: HIGHLIGHT tag: "v1.1.0"
            commit id: "[FIX] 1.1.1" type: HIGHLIGHT tag: "v1.1.1"
            commit id: "[DEV] 1.1.2-dev" type: HIGHLIGHT tag: "v1.1.2-dev"
            commit id: "[NEW] 1.2.0" type: HIGHLIGHT tag: "v1.2.0"
            commit id: "[NEW] 2.0.0" type: HIGHLIGHT tag: "v2.0.0"
            branch release

            branch "User Br"
            commit
            commit id: "new feat"

            checkout release
            merge "User Br" id: "Merge" type: HIGHLIGHT

            checkout main
            merge release id: "[NEW] 2.1.0" type: HIGHLIGHT tag: "v2.1.0"
```