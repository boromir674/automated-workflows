# Workflow go-pr-to-main.yml

### Trigger Events

If any of the below events occur, the `go-pr-to-main.yml` workflow will be triggered.

- workflow_call

Since there is a `workflow_call` _trigger_event_, this workflow can be triggered (called) by another (caller) workflow.
> Thus, it is a `Reusable Workflow`.


## Reusable Workflow

Event Trigger: `workflow_call`

### Inputs

#### Required Inputs

- `release_branch`
    - type: _string_
    - Description: Release Branch; dedicated for Sem Ver bump, Changelog updates, making RC Releases (Release Candidate), deploying to Staging, etc

#### Optional Inputs

- `main_branch`
    - type: _string_
    - Description: Name of the Main Branch. Example: main, master
    - Default: `main`

### Secrets

- `PR_RW_AND_ACTIONS_RW`
    - type: _string_
    - Required: True
    - Description: GitHub Token, with read/write permissions to PRs and read/write permissions to Github Actions Workflows

### Outputs

None
