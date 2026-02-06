# playground

## Automation workflow

This repository uses an automated workflow for issue resolution:

```mermaid
graph LR
    A[TRIGGER] --> B[Copilot coding agent]
    B --> C[PR]
    C --> D[CI]
    D --> E[auto-merge]
```

The workflow is triggered automatically, creating pull requests that are validated by CI and then auto-merged when all checks pass.
