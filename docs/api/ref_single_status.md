# Workflow go-single-status.yml

### Trigger Events

If any of the below events occur, the `go-single-status.yml` workflow will be triggered.

- workflow_call

Since there is a `workflow_call` _trigger_event_, this workflow can be triggered (called) by another (caller) workflow.
> Thus, it is a `Reusable Workflow`.


## Reusable Workflow

Event Trigger: `workflow_call`

### Inputs

#### Required Inputs

- `needs_json`
    - type: _string_
    - Description: Always supply \$\{\{ toJSON(needs) \}\} as value. It's a JSON array of caller job.needs.

#### Optional Inputs

- `allowed-failures`
    - type: _string_
    - Description: Job names that are allowed to fail and not affect the outcome, as a comma-separated list or serialized as a JSON string (ie with toJSON)
    - Default: `[]`
- `allowed-skips`
    - type: _string_
    - Description: Job names that are allowed to be skipped and not affect the outcome, as a comma-separated list or serialized as a JSON string
    - Default: `[]`

### Secrets

None

### Outputs

None

