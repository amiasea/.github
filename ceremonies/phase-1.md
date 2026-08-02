# Phase 1 — Trust Foundation Bootstrap

This phase establishes the minimum vendor and platform trust foundation required before normal Terraform Stack execution.

This is the final human-operated bootstrap boundary.

Execution context:

Human operators authenticated through vendor and platform CLIs:

* Azure CLI.
* AWS CLI.
* Google Cloud CLI.
* GitHub CLI (where required).
* HCP Terraform CLI (where required).

The purpose of this phase is to create the trust anchors that allow later automation.

## Vendor Trust Foundation

Vendor-specific trust resources are created where required.

Examples:

### Azure

```text
Azure Trust Foundation

├── Sovereign Subscription Access
├── Sovereign Resource Group
├── Prime Key Vault
├── Azure App Registration
├── Federated Credentials
└── Initial bootstrap secrets/materials

Equivalent trust foundations are established for AWS and Google Cloud where required.

These resources establish the identities and permissions required for automated execution.

HCP Terraform Foundation

Creates the initial HCP Terraform execution boundary:

Primary HCP Terraform project.
Sovereign Stack registration.
Initial Stack execution configuration.

The Sovereign Stack is registered during this phase because registration establishes the first automated execution boundary.

The Sovereign Stack itself executes later.

Prime Secret Store

The Prime Key Vault becomes the transition point between manual ceremony and automated operations.

It stores bootstrap materials such as:

GitHub App private key.
HCP Terraform organization token.
Initial federation-related secrets and configuration.

After this phase:

Vendor trust exists.
Federated authentication exists.
The Sovereign Stack is registered.
HCP Terraform has the initial execution boundary required for Stack-based operations.

This phase creates the ability to automate.

It does not deliver the operational platform.