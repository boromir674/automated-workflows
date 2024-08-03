# `release-me` - Git Ops Process

This document describes our definition of the **`release-me`** Git Ops Process.

> **release-me** process ships changes in the `head` branch into Production.


## Branches/PRs flow
```mermaid
graph LR;
  A[User Branch]
  A --PR --> B[Release]
  B--PR --> C[Main]
```

## Starting State
```mermaid

    %%{init: { 'logLevel': 'debug', 'gitGraph': {'showBranches': true, 
    'rotateCommitLabel': true,
    'showCommitLabel':true,'mainBranchName': 'main'}} }%%

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
```

## Phase 1

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