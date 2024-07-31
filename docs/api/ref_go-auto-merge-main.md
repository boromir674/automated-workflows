# Workflow go-auto-merge-main.yml

### Trigger Events

If any of the below events occur, the `go-auto-merge-main.yml` workflow will be triggered.

- workflow_call

Since there is a `workflow_call` _trigger_event_, this workflow can be triggered (called) by another (caller) workflow.
> Thus, it is a `Reusable Workflow`.


## Reusable Workflow

Event Trigger: `workflow_call`

### Inputs

#### Required Inputs

- `commit_message`
    - type: _string_
    - Description: "Merge Commit Message on main branch, when PR auto merges. Eg if 'My Shiny Python Package' is the input, then the commit message will be '[NEW] My Shiny Python Package v<semver>' for tag events with Sem Ver like 'auto-prod-1.2.0' commit message will be '[DEV] My Shiny Python Package v<semver>' for tag events with Sem Ver like 'auto-prod-1.2.0-dev' "


#### Optional Inputs

- `main_branch`
    - type: _string_
    - Description: Name of the Main Branch. Example: main, master
    - Default: `${{ vars.GIT_MAIN_BRANCH || 'main' }}`
- `release_branch`
    - type: _string_
    - Description: Name of Branch with Relase Purpose; dedicated for Sem Ver bump, Changelog updates, making RC Releases, deploying to Staging, etc
    - Default: `${{ vars.GIT_RELEASE_BRANCH || 'release' }}`

### Secrets

- `pat_token`
    - type: _string_
    - Required: True
    - Description: "Personal Access (aka fine-grained) GitHub Token, with read/write permissions to PRs and optionally read/write permissions to Github Actions Workflows. "


### Outputs

None
