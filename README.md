# CI/CD Workflows

Reusable Workflows for `CI/CD Pipelines`, implemented as `Github Actions Workflows`.

| expected green   | expected red |
| --- | --- |
|  [![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol0_green_0000_1100.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/docker_pol0_green_0000_1100.yaml)   ![](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol1_green_0001_1101.yaml/badge.svg)   ![](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol2_green_1110_0010.yaml/badge.svg)   ![](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol3_green_1111_0011.yaml/badge.svg)       |    ![](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol0_red_0100.yaml/badge.svg)    ![](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol1_red_0101.yaml.yaml/badge.svg)   ![](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol2_red_0110.yaml/badge.svg)  ![](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol3_red_0111.yaml/badge.svg)   |


## Workflows Overview

- [**Docker**](.github/workflows/docker.yml): Build Docker image and Push to Dockerhub.
- [**PyPI**](.github/workflows/pypi_env.yml): Upload Python distribution to PyPI


#### Prerequisites


List any prerequisites that users need before using your workflows. For example:

- GitHub account.
- Access to a repository.
- Passing a proper DOCKER_USER from `context`
- Passing a proper DOCKER_PASSWORD from `secrets`

### `Use Case 1: CI/Continuous Deployment`

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

### `Use Case 2: CI/Continuous Delivery`

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

### Example


## License

This project is licensed under the [License Name](LICENSE) - see the [LICENSE](LICENSE) file for details.

