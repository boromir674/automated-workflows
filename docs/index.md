# CI/CD Workflows

Reusable Workflows for `CI/CD Pipelines`, implemented as `Github Actions Workflows`.

## Quick-start

`Case 1: CI/Continuous Deployment`

"We publish to Dockerhub only tested builds"

```mermaid
graph LR
workflow_triggered("CI Start") --> rt{"Run Tests?"}
rt -- Yes --> cit
cit["Run Tests"] --> ifpass{"Succeeded?"}
ifpass -- "Yes" --> run_docker["Publish Docker"]
ifpass -- "No" --> do_not_publish_broken_build["Decline Publish"]
rt -- No --> do_not_publish_broken_build
```

```yaml

jobs:
  build_n_test:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Build Code and run Tests"

  call_docker_job:
    needs: build_n_test
    uses: boromir674/automated-workflows/.github/workflows/docker.yml@test
    with:
      DOCKER_USER: ${{ vars.DOCKER_USER }}
      acceptance_policy: 2
      image_slug: "my_app_name"
      image_tag: "1.0.0"
      tests_pass: ${{ needs.build_n_test.result == 'success' }}
      tests_run: ${{ !contains(fromJSON('["skipped", "cancelled"]'), needs.build_n_test.result) }}
    secrets:
      DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
```

`Case 2: CI/Continuous Delivery`

We publish to Dockerhub tested builds.  
Not tested builds (ie when CI Test Job is skipped for any reason), are still treated as eligible for Docker Publish.  
Useful to trigger Docker Job, without waiting for Tests.

```mermaid
graph LR
workflow_triggered("CI Start") --> rt{"Run Tests?"}
rt -- Yes --> cit
cit["Run Tests"] --> ifpass{"Succeeded?"}
ifpass -- "Yes" --> run_docker["Publish Docker"]
ifpass -- "No" --> do_not_publish_broken_build["Decline Publish"]
rt -- No --> run_docker
```

```yaml

jobs:

    build_n_test:
      runs-on: ubuntu-latest
      steps:
        - run: echo "Build Code and run Tests"

    call_docker_job:
      needs: build_n_test
      uses: boromir674/automated-workflows/.github/workflows/docker.yml@test
      with:
        DOCKER_USER: ${{ vars.DOCKER_USER }}
        acceptance_policy: 3
        image_slug: "my_app_name"
        image_tag: "1.0.0"
        tests_pass: ${{ needs.build_n_test.result == 'success' }}
        tests_run: ${{ !contains(fromJSON('["skipped", "cancelled"]'), needs.build_n_test.result) }}
      secrets:
        DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
```
