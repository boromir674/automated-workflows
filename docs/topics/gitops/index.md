# Git Ops

This document describes our definition of **`Git Ops`** process and introduces what `Automated Workflows` offer to help you implement `Git Ops`.

> **Git Ops** (`GO` or `go`), in the context of a `Software Development`, is a *practice* where Operations, such as opening a PR, merging code, triggering the CI, checking CI status, etc are **automated** using `git events`.

We offer `Resuable Workflows` as building blocks to help you implement `Git Ops`, according to our model.

> As **Git Ops Process**, we define a (semi) automated protocol, that aims to perform one or more of those (git) Operations (see above).

Notable, **Git Ops Processes** are:
| alias | Description | Example Cases |
| ----- | ----------- | -- |
| `release-me` | Release Head into Prod, with 2 PRs: `User Br --> release --> main`  | On a single developer projects |
| `board-train` | Integrate Head into Train: `User Br --> train` | On multi-developer projects |


## Git Ops Processes - Automated

We offer below solutions to help you implement concrete **`Git Ops Processes`**:

- Process [`release-me`](./release-me-process.md)

## Entities Model

```mermaid
---
title: Entities Model
---
erDiagram 
    GIT_REPO ||--|| "MAIN BRANCH" : contains
    GIT_REPO ||--|| "RELEASE BRANCH" : contains
    "MAIN BRANCH" }|..|| "PURPOSE" : serves
    "RELEASE BRANCH" }|..|| "PURPOSE" : serves

    PURPOSE |o..|{ "POLICY" : contains
    PURPOSE {
        Policy[] policies "Define what is allowed on a Branch, how PRs are being accepted, etc"
    }
```

## Object Model

```mermaid
---
title: Object Model
---
classDiagram

    class `Git Branch`{
    }
    class `Main Branch`{
    }
    class `Release Branch`{
    }

    class `Purpose`{
        Policy[]: policies
    }
    class `Prod Purpose`{
    }
    class `Release Purpose`{
    }

    class `Policy`{
    }

    `Git Branch` "0*" <.. "1" `Purpose`

    `Purpose` "0*" o.. "1*" `Policy`

    `Git Branch` "1" <|.. "1" `Main Branch` : Realization
    `Git Branch` "1" <|.. "1" `Release Branch` : Realization

    `Purpose` "1" <|.. "1" `Prod Purpose` : Realization
    `Purpose` "1" <|.. "1" `Release Purpose` : Realization

    `Main Branch` "1" o.. "1" `Prod Purpose` : Aggregation
    `Release Branch` "1" o.. "1" `Release Purpose` : Aggregation
```