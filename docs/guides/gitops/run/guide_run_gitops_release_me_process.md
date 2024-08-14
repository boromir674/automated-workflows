---
tags:
  - how-to
  - guide
---

# Run `release-me` Git Ops Process

This is a `how-to` Guide, with everything you need, to "run" the  
`release-me` process **Git Ops Process**.

## Prerequisites
- Seting Up a Repository
    - [Setup `release-me` - Phase 1](../setup/guide_setup_gitops_release_me.md)
    - [Setup `release-me` - Phase 2](../setup/guide_setup_gitops_release_me_phase_2.md)

- Single branch with all changes, based on `main`

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

## Recommendations

- Setting Up Recommended Policies
    - [Setup Automatic QA](../setup/guide_setup_main_automated_acceptance.md)
    - [Setup Human Approval](../setup/guide_setup_main_manual_acceptance.md)


## Guide


<div class="annotate" markdown>

1. Fire-up `release-me` git tag event

    ```sh
    export _tag=release-me
    git tag -d "$_tag"; git push --delete origin "$_tag";
    git tag "$_tag" && git push origin "$_tag"
    ```

2. Wait for PR to open against *base* `main` branch, from *head* `release` branch

3. Derive new Sem Ver

    {% include 'diagram-sem-ver-derivation-process.md' %}

4. Update Changelog (1)

5. If you maintain the Sem Ver in your source files, **update Sem Ver in sources**

6. Fire-up a `auto-prod-<sem ver>` git tag event (ie `auto-prod-1.2.0`)

7. If, you have setup `Human Approval`, give the Release a **green light**, by approving a Code Review.

</div>

1.  :man_raising_hand: Typically the CHANGELOG.md file!

## Congratulations :partying_face: !

Your changes should now be merged into `main`.

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
            merge release id: "[NEW] 2.1.0" type: HIGHLIGHT
```
