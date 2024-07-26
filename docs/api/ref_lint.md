# Workflow lint.yml

### Trigger Events

If any of the below events occur, the `lint.yml` workflow will be triggered.

- workflow_call

Since there is a `workflow_call` _trigger_event_, this workflow can be triggered (called) by another (caller) workflow.
> Thus, it is a `Reusable Workflow`.


## Reusable Workflow

Event Trigger: `workflow_call`

### Inputs

#### Required Inputs

None

#### Optional Inputs

- `dedicated_branches`
    - type: _string_
    - Description: 
    - Default: `master, main, dev`
- `pylint_threshold`
    - type: _string_
    - Description: 
    - Default: `8.0`
- `python_version`
    - type: _string_
    - Description: 
    - Default: `3.10`
- `run_policy`
    - type: _string_
    - Description: 
    - Default: `2`
- `source_code_targets`
    - type: _string_
    - Description: 
    - Default: `src`

### Secrets

None

### Outputs

None
