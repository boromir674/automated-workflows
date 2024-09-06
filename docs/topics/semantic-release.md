# Sem Ver - Releases

```mermaid
---
title: asda
---
quadrantChart
    title Public API
    x-axis NO Public API Changes --> Public API Changes

    y-axis Touches API NO --> Touches API YES
    quadrant-1 MAJOR
    quadrant-2 Patch or Minor
    quadrant-3 Pre-release Patch
    quadrant-4 NONE

    Public API Change: [0.65, 0.87]
    CLI commands/flags breaking: [0.80, 0.79]
    Interface input Data NEW Schema: [0.775, 0.69]
    Droping support for Python 3.8: [0.725, 0.60]

    CI only Changes: [0.30, 0.34]
    Docs only Changes: [0.20, 0.21]

    Add FEATURE X: [0.18, 0.76]
    FIX Bug x: [0.33, 0.86]
    Add support for new python 3.14: [0.25, 0.64]
```

## Semantic Release - Version Bump
> Decide on `Sem Ver Bump` Operator.

{% include 'diagram-sem-ver-derivation-process.md' %}


## Non-Public API Changes
> Essentially anything that is backwords-compatible.  
> Any non-breaking changes.

- **New** `Features`, ie

    - adding a new CLI flag
    - adding support for new python 3.99 version (in backwords-compatible way)
    - adding support for "switching between different implementations"

- **New** `fixes`, ie

    - fixing a bug (in backwords-compatible way)
    - fixing input DATA parsing
