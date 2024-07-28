---
tags:
  - Tests
  - CI
---

# Continuous Integration Automated Tests

There is a dedicated [`cicd-test`](https://github.com/boromir674/cicd-test) Github Repo acting as the **Test Suite** for this Project.

The **CI server** of our `Automated Workflows`, checks out the Test Suite, and runs it, when triggered.

[![CI Status](https://img.shields.io/github/actions/workflow/status/boromir674/automated-workflows/cicd.yml?style=plastic&logo=github-actions&logoColor=lightblue&label=Tests&color=lightgreen&link=https%3A%2F%2Fgithub.com%2Fboromir674%2Fautomated-workflows%2Factions%2Fworkflows%2Fcicd.yml)](https://github.com/boromir674/automated-workflows/actions/workflows/cicd.yml)

The `Test Suite` consists of

- a set of [**GA Workflows**](https://github.com/boromir674/cicd-test/tree/main/.github/workflows) that call our [**Docker**](https://github.com/boromir674/automated-workflows/tree/main/.github/workflows/docker.yml), [**PyPI**](https://github.com/boromir674/automated-workflows/tree/main/.github/workflows/pypi_env.yml), [**Lint**](https://github.com/boromir674/automated-workflows/tree/main/.github/workflows/lint_env.yml), and [**Code Visualization**](https://github.com/boromir674/automated-workflows/tree/main/.github/workflows/python_imports.yml) Workflows in various 
*Scenarios* and *Situations*
- a set of [**Automated Tests**](https://github.com/boromir674/cicd-test/tree/main/tests), implemented with `Pytest` (Python)
- a *Test Runner* with a CLI (`pytest -n auto`)

Test Scenarios are naturally implemented as 'caller' Workflows.  
The Tests run themselves in [Github Actions](https://github.com/boromir674/cicd-test/actions), of `cicd-test` repo.

The **Automated Tests**, (automatically) make all the assertions for Workflow Status being either **Green** or **Red**, depending on runtime conditions.

Our **CI** runs **Tests** and Passes, if all expected Green Workflows are Green and all expected Red are Red.  
In essence, in terms of logic, our **CI Status** [![CI Status](https://img.shields.io/github/actions/workflow/status/boromir674/automated-workflows/cicd.yml?style=plastic&logo=github-actions&logoColor=lightblue&label=Tests&color=lightgreen&link=https%3A%2F%2Fgithub.com%2Fboromir674%2Fautomated-workflows%2Factions%2Fworkflows%2Fcicd.yml)](https://github.com/boromir674/automated-workflows/actions/workflows/cicd.yml) encapsulates together all our Green and Red expectations, in one Signal (pass / fail).

Below is a catalog of all **Test Scenarios.**

## Docker Workflow Automated Tests

All Test Scenarios implemented for Workflow `docker.yml`.

### Green - 'Success'

These are the **Green Status** `Test Scenarios` Workflows,  
which call `docker.yml`, under conditions that should lead to **Green - Success** Status

| Workflow Status | Workflow Source Code | Scenario |
| --- | --- | --- |
[![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol0_green_0000_1100.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/docker_pol0_green_0000_1100.yaml)    |  [docker_pol0_green_0000_1100](https://github.com/boromir674/ga-python/blob/main/.github/workflows/docker_pol0_green_0000_1100.yaml) | |
[![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol1_green_0001_1101.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/docker_pol1_green_0001_1101.yaml)    |  [docker_pol1_green_0001_1101](https://github.com/boromir674/ga-python/blob/main/.github/workflows/docker_pol1_green_0001_1101.yaml) | |
[![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol2_green_1110_0010.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/docker_pol2_green_1110_0010.yaml)    |  [docker_pol2_green_1110_0010](https://github.com/boromir674/ga-python/blob/main/.github/workflows/docker_pol2_green_1110_0010.yaml) | |
[![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol3_green_1111_0011.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/docker_pol3_green_1111_0011.yaml)    |  [docker_pol3_green_1111_0011](https://github.com/boromir674/ga-python/blob/main/.github/workflows/docker_pol3_green_1111_0011.yaml) | |
|  [![](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_test_when_tag_not_given.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/docker_test_when_tag_not_given.yaml)       |  [docker_test_when_tag_not_given](https://github.com/boromir674/ga-python/blob/main/.github/workflows/docker_test_when_tag_not_given.yaml) | |


### Red - 'Failure'

These are the **Red Status** `Test Scenarios` Workflows,  
which call `docker.yml`, under conditions that should lead to **Red - Failure** Status

| Workflow Status | Workflow Source Code | Scenario |
| --- | --- | --- |
[![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol0_red_0100.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/docker_pol0_red_0100.yaml)    |  [docker_pol0_red_0100](https://github.com/boromir674/ga-python/blob/main/.github/workflows/docker_pol0_red_0100.yaml) | |
[![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol1_red_0101.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/docker_pol1_red_0101.yaml)    |  [docker_pol1_red_0101](https://github.com/boromir674/ga-python/blob/main/.github/workflows/docker_pol1_red_0101.yaml) | |
[![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol2_red_0110.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/docker_pol2_red_0110.yaml)    |  [docker_pol2_red_0110](https://github.com/boromir674/ga-python/blob/main/.github/workflows/docker_pol2_red_0110.yaml) | |
[![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/docker_pol3_red_0111.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/docker_pol3_red_0111.yaml)    |  [docker_pol3_red_0111](https://github.com/boromir674/ga-python/blob/main/.github/workflows/docker_pol3_red_0111.yaml) | |


## PyPI Workflow Automated Tests

All Test Scenarios implemented for Workflow `pypi_env.yml`.

### Green - 'Success'

These are the **Green Status** `Test Scenarios` Workflows,  
which call `pypi_env.yml`, under conditions that should lead to **Green - Success** Status

| Workflow Status | Workflow Source Code | Scenario |
| --- | --- | --- |
[![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/pypi_env_build_matrix_test.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/pypi_env_build_matrix_test.yaml)    |  [pypi_env_build_matrix_test](https://github.com/boromir674/ga-python/blob/main/.github/workflows/pypi_env_build_matrix_test.yaml) | |
[![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/pypi_test.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/pypi_test.yaml)    |  [pypi_test](https://github.com/boromir674/ga-python/blob/main/.github/workflows/pypi_test.yaml) | |

### Red - 'Failure'

These are the **Red Status** `Test Scenarios` Workflows,  
which call `pypi_env.yml`, under conditions that should lead to **Red - Failure** Status

| Workflow Status | Workflow Source Code | Scenario |
| --- | --- | --- |
| [![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/pypi_env_no_wheels_test_red.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/pypi_env_no_wheels_test_red.yaml)    |  [pypi_env_no_wheels_test_red](https://github.com/boromir674/ga-python/blob/main/.github/workflows/pypi_env_no_wheels_test_red.yaml) | |
| [![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/pypi_env_test_red.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/pypi_env_test_red.yaml)    |  [pypi_env_test_red](https://github.com/boromir674/ga-python/blob/main/.github/workflows/pypi_env_test_red.yaml) | |


## Build Workflow Automated Tests

All Test Scenarios implemented for Workflow `test_build.yml`.

### Green - 'Success'

These are the **Green Status** `Test Scenarios` Workflows,  
which call `test_build.yml`, under conditions that should lead to **Green - Success** Status

| Workflow Status | Workflow Source Code | Scenario |
| --- | --- | --- |
| [![gg](https://github.com/boromir674/ga-python/actions/workflows/.github/workflows/build_caller_check_arts_all.yaml/badge.svg)](https://github.com/boromir674/ga-python/actions/workflows/build_caller_check_arts_all.yaml)    |  [build_caller_check_arts_all](https://github.com/boromir674/ga-python/blob/main/.github/workflows/build_caller_check_arts_all.yaml) | |
| [![gg](https://github.com/boromir674/ga-python/actions/workflows/.github/workflows/build_caller_check_arts_edit_sdist.yaml/badge.svg)](https://github.com/boromir674/ga-python/actions/workflows/build_caller_check_arts_edit_sdist.yaml)    |  [build_caller_check_arts_edit_sdist](https://github.com/boromir674/ga-python/blob/main/.github/workflows/build_caller_check_arts_edit_sdist.yaml) | |
| [![gg](https://github.com/boromir674/ga-python/actions/workflows/.github/workflows/build_caller_green.yaml/badge.svg)](https://github.com/boromir674/ga-python/actions/workflows/build_caller_green.yaml)    |  [build_caller_green](https://github.com/boromir674/ga-python/blob/main/.github/workflows/build_caller_green.yaml) | |


## Lint Workflow Automated Tests

All Test Scenarios implemented for Workflow `lint.yml`.

### Green - 'Success'

These are the **Green Status** `Test Scenarios` Workflows,  
which call `lint.yml`, under conditions that should lead to **Green - Success** Status

| Workflow Status | Workflow Source Code | Scenario |
| --- | --- | --- |
| [![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/static_code_green.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/static_code_green.yaml)    |     [static_code_green](https://github.com/boromir674/ga-python/blob/main/.github/workflows/static_code_green.yaml) | |


## Code Visualization Workflow Automated Tests

All Test Scenarios implemented for Workflow `python_imports.yml`.

### Green - 'Success'

These are the **Green Status** `Test Scenarios` Workflows,  
which call `python_imports.yml`, under conditions that should lead to **Green - Success** Status

| Workflow Status | Workflow Source Code | Scenario |
| --- | --- | --- |
|  [![gg](https://github.com/boromir674/cicd-test/actions/workflows/.github/workflows/code_viz_green.yaml/badge.svg)](https://github.com/boromir674/cicd-test/actions/workflows/code_viz_green.yaml)    |  [code_viz_green](https://github.com/boromir674/ga-python/blob/main/.github/workflows/code_viz_green.yaml) | |
