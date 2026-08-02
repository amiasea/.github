# Phase 2 — Amiasea Control Plane Establishment (Manual)

This phase establishes Amiasea ownership, integrations, and credentials required for the engineering control plane.

These activities establish the identities and integrations consumed by automated Terraform execution.

## GitHub Control Plane

Create:

* Amiasea `.github` repository.
* Amiasea GitHub App.

Install:

* Amiasea GitHub App into the Amiasea organization.
* HCP Terraform GitHub App into the Amiasea organization.

## Credential Generation

Generate:

* Amiasea GitHub App private key.
* HCP Terraform organization token.

Store required credentials in the Prime Secret Store established during Phase 1.

## Output

At the completion of Phase 2:

* Amiasea has a GitHub-based control plane.
* GitHub App authentication exists.
* HCP Terraform integration exists.
* Required credentials are available for automated execution.

This phase establishes the control plane inputs required by the Engineering Delivery Model Bootstrap.