# CI/CD Workflows

[![CI Status](https://img.shields.io/github/actions/workflow/status/boromir674/automated-workflows/cicd.yml?style=plastic&logo=github-actions&logoColor=lightblue&label=CI%20Tests&color=lightgreen&link=https%3A%2F%2Fgithub.com%2Fboromir674%2Fautomated-workflows%2Factions%2Fworkflows%2Fcicd.yml)](https://github.com/boromir674/automated-workflows/actions/workflows/cicd.yml)
[![Read the Docs](https://img.shields.io/readthedocs/automated-workflows?style=plastic&logo=readthedocs&logoColor=lightblue&label=Docs&color=lightgreen&link=https%3A%2F%2Fautomated-workflows.readthedocs.io%2F)](https://automated-workflows.readthedocs.io)
[![License](https://img.shields.io/github/license/boromir674/automated-workflows?style=plastic&)](https://github.com/boromir674/automated-workflows/blob/main/LICENSE)

`Reusable Workflows` for **CI/CD Pipelines**, implemented in `Github Actions`.

> **Live Documentation** at **https://automated-workflows.readthedocs.io.**

- Source: https://github.com/boromir674/automated-workflows
- CI: https://github.com/boromir674/automated-workflows/actions


## Reusable Workflows

- **CI/CD**
  - [**Docker**](.github/workflows/docker.yml): Build Docker image and Push to Dockerhub.
  - [**Python Build**](.github/workflows/test_build.yml): Build n Test Python Distributions.
  - [**PyPI**](.github/workflows/pypi_env.yml): Upload Python distribution to PyPI
  - [**Docs Build**](.github/workflows/policy_docs.yml): Docs Site Build with `Mkdocs` or `Sphinx`
  - [**Lint**](.github/workflows/lint.yml): Static Code Analysis
  - [**Code Visualization**](.github/workflows/python_imports.yml): Visualize Python Code as an `svg` Graph of `Module Imports`
- **Git Ops**
  - [**Open PR to Boarding**](.github/workflows/go-pr-to-boarding.yml): Open a PR on a **Boarding Branch**
  - [**Acceptance as Single Job Status**](.github/workflows/go-single-status.yml): Model **Git Ops Acceptance** as one Job


> [!NOTE]
> See the **API** `References` in the [Documentation](https://automated-workflows.readthedocs.io/en/main/) for all the `Reusable Workflows`.

## Git Ops Processes
- [**`release-me`**](https://automated-workflows.readthedocs.io/en/main/topics/gitops/): Ship your Branch to `main` with 2 Steps/PRs

> [!NOTE]
> See the [`how-to` **Guides**](https://automated-workflows.readthedocs.io/en/main/guides/gitops/) for implementing your **Git Ops Processes**.

## Quickstart

### Docker

Continuously **Publish to Dockerhub** using [`docker.yml`](.github/workflows/docker.yml).

[//]: <> (Style text in <summary> .)

#### Prerequisites

- GitHub account.
- Access to a repository.
- Passing a proper DOCKER_USER from `context`
- Passing a proper DOCKER_PASSWORD from `secrets`

### `Use Case 1: CI/Continuous Deployment`

"We publish to Dockerhub **only Tested Builds**"

<details>
<!-- summary text in style of 'fancy text' -->
<summary>
  <span style="display: inline; font-weight: bold; color: #0074d9;">Quick-start</span>
</summary>

```mermaid
graph LR
workflow_triggered("CI Start") --> rt{"Do QA?"}
rt -- Yes --> cit
cit["Run Tests"] --> ifpass{"Passed?"}
ifpass -- "Yes" --> run_docker["Publish Docker"]
ifpass -- "No" --> do_not_publish_broken_build["Decline Publish"]
rt -- No --> do_not_publish_broken_build
```

```yaml
env:
  DO_QA: true

jobs:
  build_n_test:
    runs-on: ubuntu-latest
    if: always() && ${{ env.DO_QA == 'true' }}
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
</details>


### `Use Case 2: CI/Continuous Delivery`

- "Publish to Dockerhub Builds bearing a **'Tests Passed'** or a **'Tests Skipped'**"


<details>
<!-- summary text in style of 'fancy text' -->
<summary>
  <span style="display: inline; font-weight: bold; color: #0074d9;">Quick-start</span>
</summary>

- Not tested builds (ie when CI Test Job is skipped for any reason), are still treated as eligible for Docker Publish.
- Useful to trigger Docker Job, without waiting for Tests.

```mermaid
graph LR
workflow_triggered("CI Start") --> rt{"Run QA?"}
rt -- Yes --> cit
cit["Run Tests"] --> ifpass{"Passed?"}
ifpass -- "Yes" --> run_docker["Publish Docker"]
ifpass -- "No" --> do_not_publish_broken_build["Decline Publish"]
rt -- No --> run_docker
```

```yaml
env:
  DO_QA: false

jobs:
  build_n_test:
    runs-on: ubuntu-latest
    if: always() && ${{ env.DO_QA == 'true' }}
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

</details>

## License

- See the [LICENSE](LICENSE) file to read the License, under which this Project is released under.
- This project is licensed under the [GNU Affero General Public License v3.0](LICENSE).
- Free software: `GNU Affero General Public License v3.0`
