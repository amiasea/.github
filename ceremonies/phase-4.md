# Phase 4 — Strata Delivery

This phase delivers enterprise foundation capabilities through the Strata delivery model.

Strata provides the enterprise foundation and runtime capabilities consumed by downstream solution realization.

## Responsibilities

The Strata delivery phase establishes:

* Vendor Base Stack implementations.
* Foundation capability composition.
* Pillar composition.
* Strata Kubernetes Modules.
* Private Registry published capabilities.
* Foundation lifecycle management.

## Vendor Base Stacks

Vendor Base Stacks provide vendor-specific enterprise foundation capabilities.

Examples:

* Azure Enterprise Stratum.
* AWS Enterprise Stratum.
* Google Cloud Enterprise Stratum.

Vendor Base Stacks establish capabilities such as:

* Enterprise environments.
* Network context.
* Identity context.
* Hosting capabilities.
* Platform service integrations.

## Strata Kubernetes Modules

Strata Kubernetes Modules provide vendor-specific runtime realization.

They consume:

* Vendor Base Stack outputs.
* OAR-selected runtime requirements.
* TDP-generated workload artifacts.

They determine:

* Where workloads run.
* How workloads are deployed.

They do not determine:

* What workloads exist.
* Application intent.
* Organizational solution composition.

## Boundary

This phase does not:

* Establish vendor accounts.
* Create initial trust relationships.
* Configure bootstrap identities.

Those concerns are completed before Strata delivery begins.

Strata produces reusable, versioned enterprise capabilities consumed by Enterprise Portfolio and Organizational Assembly Run composition.