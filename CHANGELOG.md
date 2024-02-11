# Changelog


## 1.3.0 (2024-02-12)

### Changes

##### feature
- allow overriding the command to run for Docs Build Reusable Workflow
- add 'Docs Build' Workflow, supporting 4 Policies
- add sensible defaults to Workflow Inputs & improve output Console messages to CI UI
- allow all combinations of edit, sdist, wheel
- do NOT require Input value for PEP 440 Version
- do NOT require Input Distro Name
- Upload Artifacts tar.gz & whl
- prototype 'Test Build' Reusable Workflow
- add `Visualize Code` Workflow, that parses Module Imports to create SVG Graph

##### fix
- pin dependencies and use separate envs when both sdist and wheel builds
- debug PyPI Env Workflow
- use extra quotes to achieve shell glob expansion

##### documentation
- add Pages for 'Build Guide' and Refs for Build and Docs
- document new Automated Tests implemented on CI, as Github Caller Workflows
- add Doc Refs for 'Docs', and Doc Refs + Guide for 'Python Build'
- catalog the Automated Tests dedicated for Testing the Code Viz Workflow
- catalog new Module Imports, aka Pydeps, Workflow, in the Feature List of README.md
- add Reference Page for Module Imports, aka Pydeps, Workflow, in Docs Website
- add Reference Page for Module Imports, aka Pydeps, Workflow in Docs Website

##### refactor
- reorder Inputs key values
- fix workflow name spelling
- clean Workflow code
- add more Console Ouput to assist in debugging

##### ci
- do not trigger on 'dev' branch, and add trigger for v* and run-ci tags


## 1.2.0 (2023-12-19)

### Changes

#### features

- add new **Static Code Analysis** Workflow, leveraging `tox`, as `front-end`

#### docs

- website: add **Ref Page** for `Static Code Analysis` Reusable Workflow


## 1.1.4 (2023-12-08)

We add `Continuous Integration`, implemented in `Github Actions`.  
So, on `push` to `main`, a Workflow triggers, which runs the **[cicd-test](https://github.com/boromir674/cicd-test)** `Test Suite` (maintained in separate repo),
against our `Automated Workflows`, in various Scenarios.

The `Test Suite`, includes `Python` **Tests**, which are responsible for triggering dedicated [Test Workflows](https://github.com/boromir674/cicd-test/blob/main/.github/workflows/) of **cicd-test**, in various Scenarios and Configurations, and automatically make `Assertions`.

### Changes

#### docs

- rtd: generate Reference Pages from workflow yaml files on CI
- mkdocs: new 'References' left-side Section (lss), and nest 'Test Suite' under new 'Topics' lss
- reference-pages: add reference pages for docker.yml and pypi_env.yml reusable workflows, in Website
- readme: add ci code badges !

#### ci

- add Job, which runs the CPU-distributed tests, which trigger our Automate Workflows, in diverse Test Scenarios


## 1.1.3 (2023-12-04)

### Changes

#### docs

- add guide for CI/CD with PiPY upload in [Documentation Website](https://automated-workflows.readthedocs.io)


## 1.1.2 (2023-12-04)

### Changes

#### docs

- add simple Guide for seting up CI/CD with Dockerhub, in [Documentation Website](https://automated-workflows.readthedocs.io)


## 1.1.1 (2023-12-04)

**New Documentation Website** for Automated Workflows!
- Available at: https://automated-workflows.readthedocs.io

### Changes

#### docs

- add the 'GNU Affero General Public License v3.0' LICENSE
- update `README` with URL links to CI, Docs, and Source Code & Code Badges


## 1.1.0 (2023-11-13)

### Changes

#### features

allow controlling the `--skip-existing` *twine upload* flag, from Caller Job, when calling the **PyPI Resuable Workflow**


## 1.0.0 (2023-11-13)

**CI/CD Pipelines** for **Docker** and **PyPI**. implemented as Github Actions Resuable Workflows

- [**Docker**](.github/workflows/docker.yml): Build Docker image and Push to Dockerhub.
- [**PyPI**](.github/workflows/pypi_env.yml): Upload Python distribution to PyPI