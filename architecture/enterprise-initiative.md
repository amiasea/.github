# Enterprise Initiative

An Enterprise Initiative repository represents a versioned enterprise realization composition boundary.

An Enterprise Initiative repository contains multiple stack definitions.

Each stack definition is published as a Stack Component Configuration (SCC) through the Private Registry.

Example:

```text
enterprise-initiative-platform

        |
        | tag release

        v

Private Registry SCC

Enterprise Initiative stack definitions are Stack Component Configurations.

They define composition contracts.

They do not define deployments.

Enterprise Initiative stack definitions do not contain:

Deployment blocks.
Deployment environments.
Approval boundaries.
Runtime execution lifecycle.

Responsibilities:

Compose Organizational Assembly Run modules.
Define required enterprise realization inputs.
Declare required Strata capabilities.
Consume foundation context supplied during execution.
Establish enterprise realization composition.
Validate that required capabilities exist.

An Enterprise Initiative defines:

What enterprise realization requires.

Execution context determines:

How and where that realization occurs.
---