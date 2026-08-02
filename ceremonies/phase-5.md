# Phase 5 — Sovereign Provisioning

This phase executes the Sovereign Stack to establish the operational control plane.

The Sovereign Stack assumes:

* Vendor trust has been established.
* Federated authentication exists.
* Terraform Stack execution is available.
* Prime Secret Store access exists.

Sovereign provisioning is the transition from bootstrap trust into normal operational execution.

## Responsibilities

The Sovereign Stack establishes:

* Operational identities.
* User-assigned managed identities (UAMIs).
* Operational RBAC assignments.
* Shared operational resources.
* Day-to-day execution environments.

## Boundary

The Sovereign Stack does not:

* Create vendor accounts.
* Establish initial vendor trust.
* Create initial federation.
* Generate bootstrap credentials.
* Register itself.

Those activities occur during earlier bootstrap phases.

## Output

At the completion of Sovereign Provisioning:

* Operational identities exist.
* HCP Terraform Stacks can execute using normal operational authentication.
* Enterprise platform delivery can proceed through the standard Strata and solution delivery model.

The Sovereign Stack provides the operational foundation consumed by enterprise realization.