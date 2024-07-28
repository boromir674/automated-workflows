# Workflow pypi_env.yml

### Trigger Events

If any of the below events occur, the `pypi_env.yml` workflow will be triggered.

- workflow_call

Since there is a `workflow_call` _trigger_event_, this workflow can be triggered (called) by another (caller) workflow.
> Thus, it is a `Reusable Workflow`.


## Reusable Workflow

Event Trigger: `workflow_call`

### Inputs

#### Required Inputs

- `distro_name`
    - type: _string_
    - Description: 
- `distro_version`
    - type: _string_
    - Description: 
- `pypi_env`
    - type: _string_
    - Description: 
- `should_trigger`
    - type: _boolean_
    - Description: 

#### Optional Inputs

- `allow_existing`
    - type: _boolean_
    - Description: Continue uploading files, if one already exists, instead of Erroring
    - Default: `True`
- `artifacts_path`
    - type: _string_
    - Description: Where to download CI Artifacts into
    - Default: `downloaded-artifacts`
- `dist_folder`
    - type: _string_
    - Description: 
- `require_wheel`
    - type: _boolean_
    - Description: Require at least one Wheel Distribution to be uploaded
    - Default: `True`

### Secrets

- `TWINE_PASSWORD`
    - type: _string_
    - Required: False
    - Description: 

### Outputs

None
