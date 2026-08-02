# Phase 2 — Sovereign and Engineering Delivery Model Bootstrap

This phase transitions Amiasea from manual sovereign establishment into automated Terraform Stack execution.

The Sovereign Stack establishes the operational control-plane capabilities required for the Engineering Delivery Model.

The Engineering Delivery Model Bootstrap establishes the repositories, registry structures, and delivery constructs consumed by Enterprise Portfolio and downstream realization workflows.

This phase executes entirely through HCP Terraform Stacks.

## Execution Context

The Sovereign Stack assumes:

* Vendor trust foundations have been established.
* Federated authentication exists.
* HCP Terraform Stack execution is available.
* Sovereign Vault exists.
* Bootstrap credentials have been manually established.

The Sovereign Stack consumes these foundations and creates delegated operational capabilities.

## Sovereign Provisioning

The Sovereign Stack establishes:

* Operational identities.
* User-assigned managed identities (UAMIs).
* Workload federation identities.
* Operational RBAC assignments.
* Shared control-plane resources.
* HCP Terraform variable sets required by downstream stacks.
* Enterprise Portfolio registration.

These resources provide lower-privilege execution boundaries for automated workloads.

The Sovereign Stack establishes the operational foundation consumed by downstream delivery models. It does not become a deployment dependency for Enterprise Portfolio, Strata, Organizational Assembly Run, or Tactical Deployment Package execution.

## Vendor Operational Integration

The Sovereign Stack establishes operational authentication patterns required by supported vendors.

Examples:

### Azure

Creates:

* Operational managed identities.
* Federated workload identities.
* Role assignments.
* Cloud resource access boundaries.

Equivalent operational trust patterns may be established for AWS and Google Cloud where required.

Vendor-specific trust creation occurs during the sovereign establishment process only where it can be safely automated from existing trust foundations.

## Enterprise Portfolio Registration

The Sovereign Stack registers the Enterprise Portfolio as the first enterprise realization boundary.

The Enterprise Portfolio establishes the composition layer consumed by downstream delivery workflows.

Registration includes:

* Enterprise Portfolio Stack definition.
* Required Stack configuration.
* Required upstream references.
* Initial delivery model integration.

The Enterprise Portfolio does not establish sovereign trust or vendor foundations. It consumes the operational capabilities established by the Sovereign Stack.

## Engineering Delivery Model Bootstrap

The Engineering Delivery Model Bootstrap establishes the engineering control plane consumed by enterprise realization.

Responsibilities:

* Terraform project structure.
* Private Registry structure.
* Engineering repositories.
* Delivery model resources.
* Enterprise DSL foundations.
* Stack organization.

Initial delivery components include:

* `enterprise_strata`
* `organizational_assembly_run`
* `tactical_deployment_packages`
* `iac_module_catalog`

These components establish the structures required for:

* Strata capability delivery.
* Organizational Assembly Run composition.
* Tactical Deployment Package development.
* Infrastructure module lifecycle management.

## Boundary

This stage does not:

* Create vendor accounts.
* Establish root vendor trust.
* Create initial bootstrap credentials.
* Register the Sovereign Stack.
* Define application runtime environments.
* Deliver enterprise solutions.

Those responsibilities belong to:

* Phase 1 — Amiasea Sovereign Establishment.
* Later enterprise realization stages.

## Output

At completion of this stage:

* Sovereign operational capabilities exist.
* Delegated workload authentication exists.
* HCP Terraform Stacks can execute through operational identities.
* Enterprise Portfolio registration exists.
* Engineering repositories and registries exist.
* Engineering Delivery Model foundations exist.

The Amiasea engineering control plane is ready for Enterprise Portfolio, Strata, Organizational Assembly Run, and Tactical Deployment Package realization.
