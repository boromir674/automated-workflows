---
tags:
  - Docs
---

# Workflow policy_docs.yml

### Trigger Events

If any of the below events occur, the `policy_docs.yml` workflow will be triggered.

- workflow_call

Since there is a `workflow_call` _trigger_event_, this workflow can be triggered (called) by another (caller) workflow.
> Thus, it is a `Reusable Workflow`.


## Reusable Workflow

Event Trigger: `workflow_call`

### Inputs

#### Required Inputs

None

#### Optional Inputs

- `command`
    - type: _string_
    - Description: Docs Build Command to run
    - Default: `tox -e docs --sitepackages -vv -s false`
- `dedicated_branches`
    - type: _string_
    - Description: Branches to always want to run Docs Build. Has effect only on Policy '2'
    - Default: `main, master, dev`
- `python_version`
    - type: _string_
    - Description: Python Interpreter Version to use for Docs Build Environment
    - Default: `3.10`
- `run_policy`
    - type: _string_
    - Description: Policy for when to run Docs Build
    - Default: `2`
- `source_code_targets`
    - type: _string_
    - Description: Comma separated list of folders to watch for changes. Has effect only on Policy '2' and '3'
    - Default: `docs/`

### Secrets

None

### Outputs

None
