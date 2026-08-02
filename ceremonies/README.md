# Amiasea Bootstrap Ceremonies

The Amiasea Bootstrap Ceremonies establish the engineering control plane required for the Amiasea Engineering Delivery Model (EDM).

They describe the one-time establishment activities required to transition from enterprise ownership into an operational, self-managing engineering platform.

The ceremonies intentionally distinguish between activities that must be performed manually and those that can be delegated to Terraform Stacks.

---

## Bootstrap Philosophy

Amiasea does not attempt to automate platform establishment where platform providers do not provide a safe or complete self-actualization path.

Instead, bootstrap is divided into explicit ceremonial boundaries.

Each ceremony establishes the prerequisites consumed by the next phase.

After the bootstrap completes, ongoing engineering and platform evolution occur through normal Terraform Stack execution.

---

# Bootstrap Phases

## [Phase 0 — Enterprise Establishment](phase-0.md)

Establishes ownership of external platforms.

Examples include:

- Cloud provider accounts and subscriptions.
- GitHub Enterprise.
- HCP Terraform organization.
- Administrative ownership boundaries.

These resources exist outside the Engineering Delivery Model and are not managed by Terraform.

---

## [Phase 1 — Amiasea Sovereign Establishment](phase-1.md)

Establishes the initial sovereign control boundary.

Creates the bootstrap capabilities consumed by the Sovereign Stack, including:

- GitHub control plane.
- Sovereign HCP Terraform project.
- Sovereign Stack registration.
- Sovereign Vault.
- Bootstrap credentials.
- Initial cloud workload federation.
- Root cloud trust relationships.

This is the final manual bootstrap ceremony.

After this phase, HCP Terraform is capable of executing the Sovereign Stack.

---

## [Phase 2 — Sovereign and Engineering Delivery Model Bootstrap](phase-2.md)

Executes the Sovereign Stack through HCP Terraform.

The Sovereign Stack establishes the operational control plane by creating delegated identities, operational trust relationships, engineering repositories, registry foundations, and Enterprise Portfolio registration.

It also bootstraps the Engineering Delivery Model by establishing repositories and structures such as:

- Enterprise Strata
- Organizational Assembly Run
- Tactical Deployment Packages
- Infrastructure Module Catalog

After this phase, enterprise engineering proceeds through normal Terraform Stack execution.

---

# After Bootstrap

Bootstrap is complete after Phase 2.

From this point forward, the Engineering Delivery Model operates continuously through parallel engineering workstreams rather than additional bootstrap ceremonies.

Examples include:

- Enterprise Portfolio
- Enterprise Strata
- Organizational Assembly Run
- Tactical Deployment Packages

These workstreams evolve independently while composing together through the Engineering Delivery Model.

Bootstrap is therefore a one-time establishment process.

Everything that follows is normal engineering.