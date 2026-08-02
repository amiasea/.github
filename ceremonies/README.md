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

<table>
<thead>
<tr>
<th width="260">Phase</th>
<th width="220">Intent</th>
<th>Ceremonies</th>
</tr>
</thead>
<tbody>
<tr>
<td>

[Phase 0 — Enterprise Establishment](./phase-0.md)

</td>
<td>
Enterprise establishment
</td>
<td>
Azure account and subscription, AWS account, Google Cloud organization/project/billing, HCP Terraform organization, GitHub Enterprise and Organization
</td>
</tr>

<tr>
<td>

[Phase 1 — Trust Foundation Bootstrap](./phase-1.md)

</td>
<td>
Trust foundation bootstrap
</td>
<td>
Vendor trust roots, Azure App Registration, federated credentials, Sovereign Resource Group, Prime Key Vault, HCP Terraform project, Sovereign Stack registration
</td>
</tr>

<tr>
<td>

[Phase 2 — Amiasea Control Plane Establishment](./phase-2.md)

</td>
<td>
Amiasea control plane establishment
</td>
<td>
Amiasea `.github` repository, Amiasea GitHub App, GitHub App installation, HCP Terraform GitHub App installation, credential generation
</td>
</tr>

<tr>
<td>

[Phase 3 — Engineering Delivery Model Bootstrap](./phase-3.md)

</td>
<td>
Engineering delivery model bootstrap
</td>
<td>
Terraform projects, Private Registry structure, engineering repositories, `enterprise_strata`, `organizational_assembly_run`, `tactical_deployment_packages`, `iac_module_catalog`
</td>
</tr>

<tr>
<td>

[Phase 4 — Strata Delivery](./phase-4.md)

</td>
<td>
Strata delivery
</td>
<td>
Vendor Base Stacks, Pillars, Strata capability modules, Strata Kubernetes Modules, Private Registry publication
</td>
</tr>

<tr>
<td>

[Phase 5 — Sovereign Provisioning](./phase-5.md)

</td>
<td>
Sovereign provisioning
</td>
<td>
Operational identities, UAMIs, operational RBAC, shared operational resources, day-to-day execution environment
</td>
</tr>
</tbody>
</table>

---

# Operating Principle

The bootstrap lifecycle follows one rule:

> Establish trust manually once, then operate through Terraform Stacks.

Privileged ceremonies create the conditions for automation.

Terraform Stacks provide the ongoing execution model.