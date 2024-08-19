# Workflow go-tag-main.yml

### Trigger Events

If any of the below events occur, the `go-tag-main.yml` workflow will be triggered.

- workflow_call

Since there is a `workflow_call` _trigger_event_, this workflow can be triggered (called) by another (caller) workflow.
> Thus, it is a `Reusable Workflow`.


## Reusable Workflow

Event Trigger: `workflow_call`

### Inputs

#### Required Inputs

- `gh_email`
    - type: _string_
    - Description: GitHub Email
- `gh_username`
    - type: _string_
    - Description: GitHub Username

#### Optional Inputs

{% raw %}
- `main_branch`
    - type: _string_
    - Description: Name of the Main Branch. Example: main, master
    - Default: `${{ github.event.pull_request.base.ref || vars.GIT_MAIN_BRANCH || 'main' }}`
{% endraw %}

### Secrets

- `GH_PAT_ACTION_RW`
    - type: _string_
    - Required: True
    - Description: GitHub Personal Access Token with read/write permissions to Actions

### Outputs

None
