# Changelog


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