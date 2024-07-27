# Workflow go-pr-to-boarding.yml

### Trigger Events

If any of the below events occur, the `go-pr-to-boarding.yml` workflow will be triggered.

- workflow_call

Since there is a `workflow_call` _trigger_event_, this workflow can be triggered (called) by another (caller) workflow.
> Thus, it is a `Reusable Workflow`.


## Reusable Workflow

Event Trigger: `workflow_call`

### Inputs

#### Required Inputs

- `board_tag`
    - type: _string_
    - Description: Tag to trigger the Boarding PR. Example: board-request, board-n-release

#### Optional Inputs

- `main_branch`
    - type: _string_
    - Description: Name of the Main Branch. Example: main, master
    - Default: `main`

### Secrets

- `github_pat`
    - type: _string_
    - Required: True
    - Description: GitHub Token, with permissions to create PRs and push to the repository

### Outputs

None
