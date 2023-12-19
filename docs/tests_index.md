---
tags:
  - Tests
  - CI
---

# Automated Tests

There is a dedicated [`cicd-test`](https://github.com/boromir674/cicd-test) Github Repo acting as the **Test Suite** for this Project.

The `Test Suite` consists of

- a set of [**GA Workflows**](https://github.com/boromir674/cicd-test/tree/main/.github/workflows) that call our [**Docker**](https://github.com/boromir674/automated-workflows/tree/main/.github/workflows/docker.yml), [**PyPI**](https://github.com/boromir674/automated-workflows/tree/main/.github/workflows/pypi_env.yml), and [**Lint**](https://github.com/boromir674/automated-workflows/tree/main/.github/workflows/lint_env.yml) Workflows in various 
*Scenarios* and *Situations*
- a set of [**Automated Tests**](https://github.com/boromir674/cicd-test/tree/main/tests), implemented with `Pytest` (Python)
- a *Test Runner* with a CLI (`pytest -n auto`)

The Tests run themselves in [Github Actions](https://github.com/boromir674/cicd-test/actions), of `cicd-test` repo.

The Automated Tests, are responsible for calling the `Docker` and `PyPI` Workflows,
and depending on the runtime parameters and events (ie Docker Policy setting, CI Tests result, etc)
make the necessary assertions.


## Docker Workflow Automated Tests
| expected green pass   | expected red (because Test Job is emulated as failing) |
| --- | --- |
|  [![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol0_green_0000_1100.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/docker_pol0_green_0000_1100.yaml)    |  ![](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol0_red_0100.yaml/badge.svg)  |
|  ![](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol1_green_0001_1101.yaml/badge.svg)       |  ![](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol1_red_0101.yaml.yaml/badge.svg)  |
|  ![](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol2_green_1110_0010.yaml/badge.svg)       |  ![](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol2_red_0110.yaml/badge.svg)  |
|  ![](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol3_green_1111_0011.yaml/badge.svg)       |  ![](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol3_red_0111.yaml/badge.svg)  |

## PyPI Workflow Automated Tests

| expected green pass   | expected red (because scenario involves upload python dist to existing index, without allow_existing set to True) |
| --- | --- |
|  [![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/pypi_test.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/pypi_test.yaml)    |  ![](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/pypi_test_red.yaml/badge.svg)  |


## Lint Workflow Automated Tests

| expected green pass   | expected red |
| --- | --- |
|  [![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/static_code_green.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/static_code_green.yaml)    |    |
