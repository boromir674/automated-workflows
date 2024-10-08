# Workflow docker.yml

### Trigger Events

If any of the below events occur, the `docker.yml` workflow will be triggered.

- workflow_call

Since there is a `workflow_call` _trigger_event_, this workflow can be triggered (called) by another (caller) workflow.
> Thus, it is a `Reusable Workflow`.


## Reusable Workflow

Event Trigger: `workflow_call`

### Inputs

#### Required Inputs

- `DOCKER_USER`
    - type: _string_
    - Description: 
- `image_slug`
    - type: _string_
    - Description: 

#### Optional Inputs

- `acceptance_policy`
    - type: _string_
    - Description: 
- `image_tag`
    - type: _string_
    - Description: 
- `target_stage`
    - type: _string_
    - Description: 
- `tests_pass`
    - type: _boolean_
    - Description: 
- `tests_run`
    - type: _boolean_
    - Description: 

### Secrets

- `DOCKER_PASSWORD`
    - type: _string_
    - Required: True
    - Description: 

### Outputs
{% raw %}
- `IMAGE_REF`
    - type: _string_
    - Value: {{ "{{" }} jobs.docker_build.outputs.IMAGE_REF {{ "}}" }}
    - Description: Docker Image reference
{% endraw %}
