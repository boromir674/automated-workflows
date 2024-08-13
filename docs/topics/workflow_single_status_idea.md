---
tags:
  - gitops
  - feature
---

# Git Ops with `go-single-status.yml`

Workflow `go-single-status.yml`'s main idea is to simplify implementing (automated) **Git Ops Acceptance Requirements**, on Github/Actions

Common scenario is to have an automated process **approve a Pull Request** based on some **Acceptance Requirements**

On Github/Actions you could populate your repos' **Github Required Checks** (branch protection rules) with a set of Jobs (ie from your CI/CD pipeline Workflow), to model some **Acceptance Requirements**.  
Then the PR with **Auto Merge**, will merge once **Acceptance passed**.

Problem is that you have to *maintain this set of Jobs* on **Github Required Checks**; Jobs might also include Job Matrices.

Workflow `go-single-status.yml`'s can act as a **Single Status** of *CI QA Jobs* set, Thus
requiring to maintain only **one Job** (on *Github Required Checks*).

> This gives **flexibility** when modeling **Acceptance Requirements** in your **Git Ops** process.

> Also, allows **dynamic Acceptance Criteria**, configurable though your **CI/CD** pipeline Workflow


### Tips

> [!TIP]
> To simplify adding "Job Statuses" to Github Required Checks, provide just this Job to Github Required Checks and declare your "Job Statuses" as job.needs of a caller of this. Do not set any other value to Called job input.

> [!TIP]
> To require ALL "Job Statuses" GREEN, from caller's job.needs, supply only the  
> 'needs_json' input, with {% raw %}'${{ "{{" }} toJSON(needs) {{ "}}" }}'{% endraw %} as value.

> [!TIP]
> To have the "logic" of the 'Status Signal' be configurable at runtime for
> each of your CI/CD Pipeline runs, add the maximal set of available/implemented
> QA CI Jobs (ie unit-test, lint, e2e-test, integration-tests, audit, etc) in
> this caller's job.needs section and then control "severity" using the 
> 'allowed-failures' and 'allowed-skips' Workflow inputs.

> [!TIP]
> If you have separate CI and CD Workflows, then add this to the CI Workflow.

> [!TIP]
> Useful when populating and maintaining Github Required Checks, which involve many
> "Job Statuses", as for example if you do Git Ops involving Github Auto Merge

> [!TIP]
> Useful to dynamically control the Acceptance Criteria of PR Auto Merge
