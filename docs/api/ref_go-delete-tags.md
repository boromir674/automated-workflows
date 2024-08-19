# Workflow go-delete-tags.yml

### Trigger Events

If any of the below events occur, the `go-delete-tags.yml` workflow will be triggered.

- workflow_call

Since there is a `workflow_call` _trigger_event_, this workflow can be triggered (called) by another (caller) workflow.
> Thus, it is a `Reusable Workflow`.


## Reusable Workflow

Event Trigger: `workflow_call`

### Inputs

#### Required Inputs

None

#### Optional Inputs

None

### Secrets

- `GH_PAT_CONTENT_RW`
    - type: _string_
    - Required: True
    - Description: GitHub Personal Access Token with permission to Delete Tags; read/write permissions to Content

### Outputs

None
