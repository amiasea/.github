# Semantic Validation

The Semantic Validation Layer validates Enterprise DSL relationships before execution.

It ensures:

* Enterprise Initiative requirements match available Strata capabilities.
* OAR selections match available runtime implementations.
* TDP outputs match selected realization paths.
* Provider compatibility is valid.
* Composition relationships are valid before execution.

Example:

Invalid:

```text
Selected runtime:

Strata AWS Kubernetes Module


Artifact:

kubernetes-manifest-azure

Valid:

Selected runtime:

Strata AWS Kubernetes Module


Artifact:

kubernetes-manifest-aws

Validation occurs through:

Local developer validation.
CI validation.
Enterprise DSL tooling.