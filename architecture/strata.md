Strata provides enterprise foundation capabilities and runtime realization capabilities.

Strata consists of:

* Capability pillars.
* Vendor Base Stacks.
* Strata Kubernetes Modules.

# Pillars

Pillars are foundation capability domains composed into Vendor Base Stacks.

Examples:

* Identity.
* Network.
* Security.
* Observability.

Responsibilities:

* Define reusable platform capability composition.
* Provide capability building blocks for Vendor Base Stacks.

Pillars are not independent deployment units.

Operational policy ownership is a separate concern.

# Vendor Base Stacks

Vendor Base Stacks are versioned enterprise foundation implementations.

Examples:

* Azure Enterprise Stratum.
* AWS Enterprise Stratum.
* GCP Enterprise Stratum.

Vendor Base Stacks are operational upstream stacks.

Responsibilities:

* Establish enterprise environments.
* Provide vendor-specific enterprise capabilities.
* Compose foundation modules and capability pillars.
* Provide upstream dependencies.
* Produce foundation context consumed by downstream realization.

Outputs may include:

* Environment identifiers.
* Location information.
* Network context.
* Identity context.
* Hosting capability references.

Vendor Base Stacks establish the enterprise foundation available for realization.

# Strata Kubernetes Modules

Strata Kubernetes Modules are vendor-specific runtime realization modules.

They are Terraform modules.

They consume:

* Vendor Base Stack outputs.
* Runtime realization requirements.
* TDP-generated Kubernetes workload artifacts.

Responsibilities:

* Implement vendor-specific Kubernetes realization.
* Translate workload artifacts into runtime resources.
* Manage vendor-specific Kubernetes resources.

Examples:

```text
Strata Azure Kubernetes Module

uses:

Azure Kubernetes resources


Strata AWS Kubernetes Module

uses:

AWS EKS resources

Strata Kubernetes Modules determine:

Where Kubernetes workloads run.
How Kubernetes workloads are deployed.

They do not determine:

What workloads exist.