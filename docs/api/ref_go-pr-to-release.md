# Workflow go-pr-to-release.yml

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
    - Description: Branch with 'Release' Purpose

#### Optional Inputs

- `backwords_compatibility`
    - type: _string_
    - Description: "Etheir 'backwords-compatible' or 'backwords-incompatible'. If 'backwords-incompatible', then it hints for major Sem Ver bump, if this released. If 'backwords-compatible', then when this is the only change for release, it hints for patch or minor Sem Ver bump. If 'backwords-compatible', then when there are more changes for release, this does not impose minimum Bump level. "

- `forbidden_branches`
    - type: _string_
    - Description: "Comma separated list of branches, which are forbidden to be merged into Release Branch. Set to main,master to crash this Job, in case accidentally the main/master branch was detected as User Branch. "

    - Default: `main,master`

### Secrets

- `github_pat`
    - type: _string_
    - Required: True
    - Description: GitHub Token, with read/write permissions to PRs and read/write permissions to Github Actions Workflows

### Outputs

None
