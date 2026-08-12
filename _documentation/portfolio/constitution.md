# Portfolio Constitution

Portfolio is the enterprise orchestration boundary for realizing approved enterprise solutions within Amiasea.

Portfolio coordinates enterprise realization without owning the implementation of applications, organizational assemblies, or hosting infrastructure.

> **Portfolio orchestrates realization; it does not implement the capabilities being realized.**

## Purpose

Portfolio exists to coordinate the execution of enterprise realization across the organizational and platform boundaries required to deliver a solution.

Its responsibilities include:

* composing approved realization inputs;
* establishing execution context;
* coordinating organizational assembly;
* consuming Strata hosting capabilities;
* establishing deployment environments; and
* controlling enterprise execution.

Portfolio provides the enterprise-level boundary within which realization proceeds.

## Enterprise Realization

Enterprise realization is the process through which an enterprise solution is assembled and executed from its constituent organizational and application capabilities.

The realization model separates:

* enterprise orchestration;
* organizational assembly;
* application realization; and
* platform hosting.

These concerns have distinct ownership and lifecycles.

Portfolio coordinates them without absorbing their responsibilities.

```text
Portfolio
    │
    ├── Organizational Assembly
    │       └── OAR
    │
    ├── Application Realization
    │       └── TDP
    │
    └── Hosting
            └── Strata
```

## Enterprise Portfolio

The Enterprise Portfolio is the operational Terraform boundary through which enterprise realization is executed.

A Portfolio stack composes the inputs required for a particular enterprise realization and controls when that realization proceeds.

The Portfolio currently operates as a single stack associated with its repository, with its stack component and deployment configuration maintained at the repository root.

The environment model has not yet been fully established.

Portfolio therefore provides the execution boundary without prematurely defining the eventual structure of its environment streams.

## Enterprise Composition

Portfolio consumes organizational and application realization rather than implementing those concerns itself.

An Organizational Assembly Run represents an organization's solution assembly and composes the applicable Tactical Deployment Packages.

A Tactical Deployment Package represents application realization.

Portfolio coordinates these existing realization boundaries as part of enterprise execution.

> **Portfolio composes realization; OARs assemble solutions; TDPs realize applications.**

## Relationship to Strata

Strata establishes the hosting capabilities upon which enterprise realization can execute.

Portfolio does not own Strata resources or reproduce Strata's hosting implementation.

Instead, Portfolio consumes the capabilities established by Strata and provides the enterprise execution context in which those capabilities are used.

Strata therefore maintains its own lifecycle independently of Portfolio.

A Strata capability does not need to become a Portfolio artifact merely because Portfolio consumes it.

> **Portfolio consumes hosting capability; Strata owns its establishment and lifecycle.**

## Relationship to Consumers

Portfolio operates above organizational and application realization boundaries.

Organizations remain responsible for their assembly models.

Applications remain responsible for their realization packages.

Portfolio does not redefine those responsibilities merely because it coordinates their execution.

Likewise, Portfolio does not become the owner of application or platform resources simply because those resources participate in an enterprise realization.

## Execution Boundary

Portfolio is the boundary at which enterprise realization becomes an operational execution.

It provides the context necessary to determine:

* what realization is being executed;
* which approved inputs participate;
* where the realization is executed;
* when execution occurs; and
* what enterprise controls govern execution.

Portfolio does not determine the internal implementation of the realization.

The execution boundary therefore separates **enterprise orchestration** from **implementation ownership**.

## Environment

Environment is an execution concern of Portfolio.

A Portfolio realization requires an environment in which its constituent capabilities can be established and operated.

The precise environment model, including environment streams and their relationship to Portfolio execution, remains to be established.

Portfolio should therefore distinguish the concept of an execution environment from the infrastructure constructs used to implement it.

> **An environment is an execution context, not merely an infrastructure boundary.**

## Operational Scope

Portfolio establishes the context in which enterprise realization is executed but does not assume responsibility for every operational concern of the resulting system.

Application realization remains responsible for application-specific implementation.

Strata remains responsible for hosting capabilities.

Operational concerns that arise from the behavior of an established realization may require a distinct operational scope as the environment model develops.

This boundary prevents Portfolio from becoming a general-purpose operational authority.

## Architectural Boundaries

Portfolio should preserve the following boundaries:

* **Portfolio** — enterprise orchestration and execution;
* **OAR** — organizational solution assembly;
* **TDP** — application realization;
* **Strata** — hosting capability and platform realization.

Each boundary should retain its own purpose, lifecycle, and responsibility.

Portfolio should coordinate these boundaries without collapsing them into a single implementation model.

> **Enterprise coherence comes from explicit relationships between bounded responsibilities, not from centralizing their implementation.**

## Opinionated Enterprise Realization

Portfolio is intentionally opinionated about how enterprise realization is composed and executed.

It does not attempt to support every technically possible deployment arrangement.

An implementation may be technically viable while remaining outside the supported enterprise realization model.

Portfolio should therefore favor explicit, repeatable, and governed realization paths over arbitrary infrastructure composition.

## Scope

Portfolio is not:

* a general-purpose infrastructure authority;
* an application implementation boundary;
* an organizational assembly boundary;
* a Kubernetes hosting platform; or
* a runtime operations system.

Its purpose is narrower:

> **Portfolio provides the enterprise orchestration and execution boundary through which approved realization is coordinated.**
