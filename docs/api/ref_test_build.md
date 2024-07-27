# Workflow test_build.yml

### Trigger Events

If any of the below events occur, the `test_build.yml` workflow will be triggered.

- workflow_call

Since there is a `workflow_call` _trigger_event_, this workflow can be triggered (called) by another (caller) workflow.
> Thus, it is a `Reusable Workflow`.


## Reusable Workflow

Event Trigger: `workflow_call`

### Inputs

#### Required Inputs

None

#### Optional Inputs

- `artifact_name`
    - type: _string_
    - Description: CI Artifact Name (id / alias) for uploading Distros, such as files .tar.gz, .whl(s)
    - Default: `dist`
- `build_installation`
    - type: _string_
    - Description: Code Installation Modes, for running Tests
    - Default: `edit sdist wheel`
- `job_matrix`
    - type: _string_
    - Description: 
    - Default: `{"platform": ["ubuntu-latest"], "python-version": ["3.10"]}`
- `run_policy`
    - type: _string_
    - Description: 0 = Off, 1 = On
    - Default: `1`
- `typecheck_policy`
    - type: _string_
    - Description: 0 = Off, 1 = On, 2 = Allow Fail
    - Default: `1`

### Secrets

None

### Outputs

- `COVERAGE_ARTIFACT`
    - type: _string_
    - Value: ${{ jobs.test_build.outputs.COVERAGE_ARTIFACT }}
    - Description: CI Artifact Name (id / alias) of uploaded Coverage XML
