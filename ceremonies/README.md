# Bootstrap Ceremonies

The Amiasea operating model is established through a sequence of bootstrap ceremonies.

These ceremonies intentionally separate:

* Human-owned enterprise establishment.
* Privileged trust foundation creation.
* Control plane establishment.
* Terraform Stack-based engineering bootstrap.
* Enterprise capability delivery.
* Operational platform provisioning.

The goal is to minimize privileged bootstrap operations and transition as quickly as possible into normal Terraform Stack execution.

---

# Phase Summary

<div style="display: flex; flex-direction: column; gap: 12px;">

<div style="display: grid; grid-template-columns: 320px 220px 1fr; gap: 16px; font-weight: bold; border-bottom: 1px solid #d0d7de; padding-bottom: 8px;">
<div>Phase</div>
<div>Intent</div>
<div>Ceremonies</div>
</div>

<div style="display: grid; grid-template-columns: 320px 220px 1fr; gap: 16px;">
<div><a href="./phase-0.md">Phase 0 — Enterprise Establishment</a></div>
<div>Enterprise establishment</div>
<div>Azure account and subscription, AWS account, Google Cloud organization/project/billing, HCP Terraform organization, GitHub Enterprise and Organization</div>
</div>

<div style="display: grid; grid-template-columns: 320px 220px 1fr; gap: 16px;">
<div><a href="./phase-1.md">Phase 1 — Trust Foundation Bootstrap</a></div>
<div>Trust foundation bootstrap</div>
<div>Vendor trust roots, Azure App Registration, federated credentials, Sovereign Resource Group, Prime Key Vault, HCP Terraform project, Sovereign Stack registration</div>
</div>

<div style="display: grid; grid-template-columns: 320px 220px 1fr; gap: 16px;">
<div><a href="./phase-2.md">Phase 2 — Amiasea Control Plane Establishment</a></div>
<div>Amiasea control plane establishment</div>
<div>Amiasea <code>.github</code> repository, Amiasea GitHub App, GitHub App installation, HCP Terraform GitHub App installation, credential generation</div>
</div>

<div style="display: grid; grid-template-columns: 320px 220px 1fr; gap: 16px;">
<div><a href="./phase-3.md">Phase 3 — Engineering Delivery Model Bootstrap</a></div>
<div>Engineering delivery model bootstrap</div>
<div>Terraform projects, Private Registry structure, engineering repositories, <code>enterprise_strata</code>, <code>organizational_assembly_run</code>, <code>tactical_deployment_packages</code>, <code>iac_module_catalog</code></div>
</div>

<div style="display: grid; grid-template-columns: 320px 220px 1fr; gap: 16px;">
<div><a href="./phase-4.md">Phase 4 — Strata Delivery</a></div>
<div>Strata delivery</div>
<div>Vendor Base Stacks, Pillars, Strata capability modules, Strata Kubernetes Modules, Private Registry publication</div>
</div>

<div style="display: grid; grid-template-columns: 320px 220px 1fr; gap: 16px;">
<div><a href="./phase-5.md">Phase 5 — Sovereign Provisioning</a></div>
<div>Sovereign provisioning</div>
<div>Operational identities, UAMIs, operational RBAC, shared operational resources, day-to-day execution environment</div>
</div>

</div>

---

# Operating Principle

The bootstrap lifecycle follows one rule:

> Establish trust manually once, then operate through Terraform Stacks.

Privileged ceremonies create the conditions for automation.

Terraform Stacks provide the ongoing execution model.