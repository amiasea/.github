# Organizational Assembly Run (OAR)

An Organizational Assembly Run represents an organization's solution assembly boundary.

Each organization owns one OAR repository.

OARs are Terraform modules.

The OAR repository contains organization-specific assembly modules that compose application capabilities into organizational solutions.

Responsibilities:

* Assemble TDP modules into solution contexts.
* Define organizational realization patterns.
* Declare required foundation context.
* Select compatible realization paths.
* Select compatible runtime implementations when required.
* Map TDP outputs to platform implementations.
* Provide organizational solution assembly into enterprise composition.

OARs determine:

* Which application capabilities belong together.
* Which realization paths are supported.
* Which platform implementations satisfy workload requirements.

OARs do not own:

* Cloud foundations.
* Vendor infrastructure primitives.
* Vendor Kubernetes implementation.

Example:

```text
Organization A OAR

Supports:

Azure Kubernetes realization
AWS Kubernetes realization


Organization B OAR

Supports:

Azure Kubernetes realization

Different organizations may have different OAR contracts because each organization owns its assembly model.