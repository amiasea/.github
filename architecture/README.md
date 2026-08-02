# Amiasea Architecture

This directory contains the architectural model defining how enterprise intent is transformed into realized solutions.

The model separates:

* Enterprise orchestration.
* Enterprise composition.
* Organizational assembly.
* Application realization.
* Foundation capability.
* Runtime operations.
* Developer experience.

The architecture is designed around declarative composition, versioned capabilities, and validated execution.

---

# Architecture Model

## Enterprise Architecture

Defines the overall enterprise realization model, architectural boundaries, and governance model.

[Enterprise Architecture](./enterprise-architecture.md)

---

## Enterprise Portfolio

Defines the operational execution boundary.

The Enterprise Portfolio composes enterprise realization, provides execution context, and owns approval and execution history.

[Enterprise Portfolio](./enterprise-portfolio.md)

---

## Enterprise Initiative

Defines versioned enterprise realization composition.

Enterprise Initiative repositories publish Stack Component Configurations (SCCs) that describe enterprise composition contracts.

[Enterprise Initiative](./enterprise-initiative.md)

---

## Organizational Assembly Run (OAR)

Defines the organization-owned solution assembly boundary.

OARs are Terraform modules that assemble application capabilities into organizational solutions.

[Organizational Assembly Run](./organizational-assembly-run.md)

---

## Tactical Deployment Package (TDP)

Defines application realization.

TDPs are Terraform modules that contain application realization logic, resources, configuration, and workload artifacts.

[Tactical Deployment Package](./tactical-deployment-package.md)

---

## Strata

Defines enterprise foundation and runtime capabilities.

Strata provides vendor foundation implementations, capability composition, and runtime realization modules.

[Strata](./strata.md)

---

## Semantic Validation

Defines validation of Enterprise DSL relationships before execution.

Semantic validation ensures enterprise composition, capability requirements, and realization paths are compatible.

[Semantic Validation](./semantic-validation.md)

---

## Cross-Cutting Work Streams

Defines supporting enterprise capabilities that enable and operate the model.

Includes:

* Developer ergonomics.
* Enterprise DSL tooling.
* Runtime operations.
* Operational feedback loops.

[Cross-Cutting Work Streams](./work-streams.md)

---

# Realization Flow

```text
Enterprise Intent

        |
        v

Enterprise Portfolio

        |
        v

Enterprise Initiative SCC

        |
        v

Organizational Assembly Run

        |
        v

Tactical Deployment Package

        |
        v

Runtime Realization

        ^
        |
        
Strata Foundation Capabilities
```

### The architecture establishes clear ownership boundaries:

Enterprise Portfolio orchestrates execution.
Enterprise Initiative defines enterprise composition.
OAR defines organizational assembly.
TDP defines application realization.
Strata provides foundation and runtime capabilities.
Semantic Validation ensures composition correctness before execution.
