# Workflow test_build.yml

### Trigger Events

If any of the below events occur, the `test_build.yml` workflow will be triggered.

- workflow_call

Since there is a `workflow_call` _trigger_event_, this workflow can be triggered (called) by another (caller) workflow.
> Thus, it is a `Reusable Workflow`.

- BRANCH_WITH_SEM_VER_TAGS: master

## Environment Variables

Environment variables set in the workflow's `env` section:

- CARRIER_TEMP: empemeral-br-ci-quick-win-test

## Reusable Workflow

Event Trigger: `workflow_call`

### Inputs

#### Required Inputs

None

#### Optional Inputs

- `artifact_name`
    - type: _string_
    - Description: 
    - Default: `dist`
- `build_installation`
    - type: _string_
    - Description: 
    - Default: `edit sdist wheel`
- `job_matrix`
    - type: _string_
    - Description: 
    - Default: `{"platform": ["ubuntu-latest"], "python-version": ["3.10"]}`
- `run_policy`
    - type: _string_
    - Description: 
    - Default: `1`
- `typecheck_policy`
    - type: _string_
    - Description: 
    - Default: `1`

### Secrets

None

### Outputs

- `COVERAGE_ARTIFACT`
    - type: _string_
    - Value: ${{ jobs.test_build.outputs.COVERAGE_ARTIFACT }}
    - Description: Artifact Name (id / alias) of Coverage XML
