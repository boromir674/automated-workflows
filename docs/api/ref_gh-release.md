# Workflow gh-release.yml

### Trigger Events

If any of the below events occur, the `gh-release.yml` workflow will be triggered.

- workflow_call

Since there is a `workflow_call` _trigger_event_, this workflow can be triggered (called) by another (caller) workflow.
> Thus, it is a `Reusable Workflow`.


## Reusable Workflow

Event Trigger: `workflow_call`

### Inputs

#### Required Inputs

- `tag`
    - type: _string_
    - Description: Git Tag to use for the GH Release

#### Optional Inputs

- `artifact`
    - type: _string_
    - Description: Name of the Artifact to download from CI, and then bundle in the GH Release
- `draft`
    - type: _boolean_
    - Description: Whether to make a Draft Release or not

### Secrets

- `gh_token`
    - type: _string_
    - Required: False
    - Description: GitHub Token, with permissions to create Releases

### Outputs

None
