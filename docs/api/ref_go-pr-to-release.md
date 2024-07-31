# Workflow go-pr-to-release.yml

| Git Ops Process | Phase 1a | Phase 1b |
| - | - | - |
| `release-me` | THIS | |

### Trigger Events

If any of the below events occur, the `go-pr-to-release.yml` workflow will be triggered.

- workflow_call

Since there is a `workflow_call` _trigger_event_, this workflow can be triggered (called) by another (caller) workflow.
> Thus, it is a `Reusable Workflow`.


## Reusable Workflow

Event Trigger: `workflow_call`

### Inputs

#### Required Inputs

- `release_branch`
    - type: _string_
    - Description: Branch to release

#### Optional Inputs

None

### Secrets

- `github_pat`
    - type: _string_
    - Required: True
    - Description: GitHub Token, with read/write permissions to PRs and read/write permissions to Github Actions Workflows

### Outputs

None
