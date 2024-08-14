# Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/).

## 1.7.1-dev1 (2024-09-15)

Adding `How-to` Guide for **Running** `release-me` **Git Ops Process**.

### Changes

##### docs

- write user-friendly content for Git Ops Guides landing page
- add page for 'Run release-me Git Ops Process' How-to Guide
- improve Test Suite Development Flow Chart


## 1.7.1-dev (2024-09-13)

Adding `Documentation` Content for **Git Ops Process**
- How-to Guides
  - Setup `Automatic Acceptance` to protect your `main` branch
  - Setup `Manual Acceptance` to add manual intervention as merge requirement

### Changes

##### docs
- add Guide Page for 'Protecting Branch' with Auto QA
- update README.md to match CI/CD and Git Ops features
- add 'Setup Manual Acceptance' How-to Guide, of 'release-me' Git Ops Process


## 1.7.0 (2024-08-03)

`Phase 2` of `release-me` **Git Ops Process**
- Offers `Reusable Workflow`
- Offers `How-to` setup **Guide**

### Changes

##### feature
- add `.github/workflows/go-auto-merge-main.yml` Reusable Workflow
- allow declaring backwords-compatibility (or not) in `release-me' *Phase 2*

##### docs
- add Ref Page, Topics and Guide in Docs Site
- improve Git Ops Ref Pages


## 1.6.2 (2024-07-30)

Document **Git Ops** and `release-me` **Git Ops Process** in Docs Website.
- Add `Guide` Page for `How-to` setup a new `release-me` **Git Ops Process**


## 1.6.0 (2024-07-29)

Support for **`Git Ops 'release-me'` Phase 1 Process, through 2 Reusable Workflows.

### Changes

##### feature
- implement pr to release and main as building blocks for Git Ops
- enable 'release' PR auto merge, in go-pr-to-release

##### ci
- dedicate 2 _gitops-pr-to-{release,main}.yml Workflows for release-me Git Ops Process phase 1
- run release-me automated Test Cases from Test Suite, in Job Matrix

##### docs
- update automatic ref pages
- docs: update site with Git Ops Ref Pages for release and main PRs


## 1.5.0

New **`Single Status`** Workflow for **Git Ops**,

### Changes

##### feature
- improve step.name content
- add 'Single Status' Workflow for Git Ops

##### build
- add docker and compose files for docs_dev server

##### git ops
- pass in PAT with PR r/w and Actions r/w; change logic of Pipe Config based on Gitops Signal

##### docs
- add all current User Facing Worklflows in Site Navigation
- redesign README.md with better sections and collapsible content
- add 'topic' about go-single-status.yml workflow idea
- automatically generate API Ref Pages and Add them to Site Navigation, if missing
- do not generate Ref Pages during Read The Docs Builds


## 1.4.0 (2024-03-15)

**2 New Reusable Workflows:**
- [`Make a Github Release`](./.github/workflows/gh-release.yml)
- [`Git Ops: PR to Boarding`](./.github/workflows/go-pr-to-boarding.yml)

### Changes

##### feature
- allow passing custom GH_TOKEN for gh CLI
- add GH Release Reusable Workflow with requred input 'tag'
- close PR if already open, and then open new one, for GitOps Pr to Boarding Workflow
- add Reusable Workflow for opening PR 'User Branch'  -->  'Boarding'


## 1.3.0 (2024-02-12)

### Changes

##### feature
- allow overriding the command to run for Docs Build Reusable Workflow
- add `Docs Build` Workflow, that builds the **Documentation Pages**, with 4 Policies
- add sensible defaults to Workflow Inputs & improve output Console messages to CI UI
- allow all combinations of edit, sdist, wheel
- do NOT require Input value for PEP 440 Version
- do NOT require Input Distro Name
- Upload Artifacts tar.gz & whl
- add `Test Build` Workflow, that **Builds n Test Python**, with 4 Policies
- add `Visualize Code` Workflow, that parses Module Imports to create **SVG Graph**

##### fix
- pin dependencies and use separate envs when both sdist and wheel builds
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
- do not trigger on 'dev' branch, and add trigger for 'v*' and 'run-ci' tags


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