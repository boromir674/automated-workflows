# `auto-prod` - Git Ops Process

This document describes our definition of the **`auto-prod`** Git Ops Process.

> **auto-prod** process takes the `release` branch and:
- creates a Release Candidate Tag, which has a Sem Ver bearing Pre-Release information
- enables **Auto Merge** on `main` branch


## Branches/PRs flow
```mermaid
graph LR;
  B[Release]
  B--PR --> C[Main]
```
