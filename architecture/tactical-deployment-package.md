# Tactical Deployment Package (TDP)

A Tactical Deployment Package represents application realization.

TDPs are Terraform modules.

TDPs define the application realization package required to deploy an application capability.

Responsibilities:

* Contain application-specific configuration.
* Define application realization requirements.
* Include Score workload contracts when applicable.
* Produce versioned application realization artifacts.
* Publish release artifacts.
* Define Terraform resources required for application realization.

TDPs are not Kubernetes-specific.

A TDP may contain:

* Application infrastructure resources.
* Cloud service resources.
* Data resources.
* Messaging resources.
* Configuration resources.
* Secret integration.
* Identity bindings.
* Kubernetes workload definitions.
* Application deployment artifacts.

Example:

```text
TDP Release

application configuration

Terraform resources

score.yaml

kubernetes-manifest-azure

kubernetes-manifest-aws

application artifacts

Score is a workload representation used within application realization.

It is not an architectural boundary.

The TDP defines:

What should be realized.

It does not define:

Where enterprise capability exists.