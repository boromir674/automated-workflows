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

## Concept Model & Policies

<!DOCTYPE html>
<html lang="en">
<head>

  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Git Ops Diagrams</title>


  <style>
    .container {
      display: flex;
      flex-wrap: wrap;
      margin: 20px 0;
    }
    .diagram {
      flex: 3 1 60%;
      padding: 10px;
    }
    .text {
      flex: 2 1 40%;
      padding: 10px;
    }
    @media (max-width: 768px) {
      .container {
        flex-direction: column;
      }
      .diagram, .text {
        flex: 1 1 100%;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="diagram">
      <pre class="mermaid">
        erDiagram 
            GIT_REPO ||--|| "MAIN BRANCH" : has
            GIT_REPO ||--|| "RELEASE BRANCH" : has
            "MAIN BRANCH" }|..|| "PURPOSE" : associates_with
            "RELEASE BRANCH" }|..|| "PURPOSE" : associates_with
            PURPOSE |o..|{ "POLICY" : implies
            PURPOSE {
                Policy[] policies "Define what is allowed on a Branch, how PRs are being accepted, etc"
            }
      </pre>
    </div>
    <div class="text">
      <h2>Common Policies</h2>
      <ul>
        <li>Only Release Tags</li>
        <li>Allows Pre-Release Tags</li>
        <li>Requires PR for merge</li>
        <li>Requires Status Checks for PR</li>
            <ul>
                <li>Requires CI to Pass</li>
                <li>Requires Integration Tests to Pass</li>
            </ul>
        <li>Requires Webhook Status for PR</li>
        <li>Requires Peer Code Review</li>
      </ul>
    </div>
  </div>
  <script type="module">
    import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
    mermaid.initialize({ startOnLoad: true });
  </script>
</body>
</html>
