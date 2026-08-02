# Phase 1 — Amiasea Sovereign Establishment (Manual)

This phase establishes the initial Amiasea sovereign control boundary.

These activities create the identities, integrations, repositories, secrets, and trust relationships required for the Sovereign Stack to execute and establish delegated automation capabilities.

This phase is a manual establishment ceremony. It creates the minimum privileged foundation required for subsequent Terraform-managed execution through HCP Terraform Stacks.

## GitHub Control Plane

Create:

* Amiasea `.github` repository.
* Amiasea GitHub App.

Install:

* Amiasea GitHub App into the Amiasea organization.
* HCP Terraform GitHub App into the Amiasea organization.

Establish:

* GitHub repository ownership and access boundaries required by the Engineering Delivery Model.

## HCP Terraform Control Plane

Create:

* Amiasea HCP Terraform organization.
* Amiasea HCP Terraform project.

Register:

* Create Sovereign TFE Project
* Sovereign Stack.

Configure:

* Sovereign Stack VCS integration.
* Sovereign Stack deployment configuration.

The Sovereign Stack is the first managed control-plane workload. Its registration is completed during this manual ceremony because it establishes the authority boundary used by subsequent automated execution.

## Sovereign Vault Establishment

Create:

* Amiasea Sovereign Vault.

The Sovereign Vault is the initial Prime Secret Store for control-plane credentials.

Store:

* Amiasea GitHub App private key.
* HCP Terraform organization token.

These credentials are manually established because they are bootstrap credentials required for Sovereign Stack operation and cannot be injected through Stack variable inputs.

The Sovereign Stack consumes the Sovereign Vault as an existing control-plane dependency and does not create the vault itself.

## Cloud Trust Establishment

Create required cloud vendor trust relationships that cannot be established through OIDC-driven Terraform execution.

Establish:

* Root cloud identities.
* Initial workload federation required by the Sovereign Stack.
* HCP Terraform Stack OIDC trust relationship.
* Initial cloud provider authentication boundaries.

These identities provide the minimum authority required for Sovereign Stack execution.

The Sovereign Stack uses these foundations to create delegated identities and lower-privilege workload federations consumed by downstream delivery capabilities.

## Output

At the completion of Phase 1:

* Amiasea has an established GitHub-based control plane.
* HCP Terraform is configured for Sovereign Stack execution.
* Sovereign Stack registration exists.
* The Sovereign Vault exists.
* Bootstrap credentials required by the Sovereign Stack are available.
* Root cloud trust relationships exist.

This phase establishes the authority boundary required for the Sovereign Stack to initialize delegated Engineering Delivery Model capabilities.
