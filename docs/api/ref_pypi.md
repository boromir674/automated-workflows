# Workflow pypi.yml

### Trigger Events

If any of the below events occur, the `pypi.yml` workflow will be triggered.

- workflow_call

Since there is a `workflow_call` _trigger_event_, this workflow can be triggered (called) by another (caller) workflow.
> Thus, it is a `Reusable Workflow`.


## Reusable Workflow

Event Trigger: `workflow_call`

### Inputs

#### Required Inputs

- `TWINE_USERNAME`
    - type: _string_
    - Description: 
- `artifacts_path`
    - type: _string_
    - Description: 
- `distro_name`
    - type: _string_
    - Description: 
- `distro_version`
    - type: _string_
    - Description: 
- `pypi_server`
    - type: _string_
    - Description: 
- `should_trigger`
    - type: _boolean_
    - Description: 

#### Optional Inputs

- `dist_folder`
    - type: _string_
    - Description: 

### Secrets

- `TWINE_PASSWORD`
    - type: _string_
    - Required: True
    - Description: 

### Outputs

None
