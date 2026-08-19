# Strata Ontology

The Strata ontology defines the semantic concepts describing the hosting domain established by Strata.

Strata establishes the hosting model through which applications are hosted and the Collective capabilities that serve those applications.

Strata has jurisdiction over the hosting boundaries it establishes, including promotional stages, Hosting environments, logical cluster domains, and Collective responsibilities.

Strata is delivered through three promotional stages:

```text
Speculative
    ↓
Prospective
    ↓
Operative
```

The stages share a semantic lifecycle but have distinct responsibilities and realization mechanics.

Detailed stage semantics are documented separately:

* [Speculative Promotion](promotion/stages/speculative.md)
* [Prospective Promotion](promotion/stages/prospective.md)
* Operative Promotion

# Resources

A Strata resource is a semantic object recognized by the Strata Resource Model.

> **A Strata resource is a recognized hosting-domain concept, not a Terraform or provider resource.**

## Resource Classes

A resource class identifies a kind of thing in the Strata domain.

Examples include:

* Network
* Subnet
* API Management
* Key Management
* Kubernetes

A resource class describes the semantic kind of resource. A resource instance represents an occurrence of that class.

```text
Resource Class
    Network

Resource Instances
    development-network
    production-network
```

The resource graph establishes instance identity, attributes, and relationships.

## Vendor Independence

The Resource Model is independent of provider-specific resource naming and configuration.

```text
Azure resource ──┐
AWS resource ────┼──→ Strata resource class
GCP resource ────┘
```

Different provider resources may realize the same Strata resource class.

> **Infrastructure establishes the resource; the Resource Model establishes its Strata meaning.**

# Jurisdiction

Jurisdiction establishes the semantic boundary within which a responsibility is realized and governed.

Strata has jurisdiction over the hosting domain it establishes, including:

* promotional stages;
* Hosting environments;
* logical cluster domains; and
* Collective responsibilities.

Jurisdiction concerns purpose, responsibility, lifecycle, and semantic boundaries rather than provider resource types.

A provider construct may realize a jurisdictional boundary without defining its meaning.

For example, a cloud subscription may provide the infrastructure boundary within which a promotional stage is realized, while a resource group may realize an environment boundary within that stage.

Neither provider construct defines the Strata concept by itself.

> **Strata defines hosting boundaries; infrastructure realizes them.**

# Landing-Zone Boundary

Cloud-vendor preparation is outside the Strata delivery lifecycle.

A landing zone establishes the vendor-specific infrastructure context that a delivery platform is permitted to consume. This may include:

* cloud accounts or subscriptions;
* billing relationships;
* provider-level organizational structure;
* privileged identities;
* service principals or equivalent principals;
* federation and trust prerequisites;
* baseline permissions;
* regional or organizational constraints; and
* other vendor-specific preparation required before delivery can operate.

Landing zones may be established manually, through Terraform, through provider-native tooling, or through a combination of mechanisms.

The landing-zone lifecycle does not become part of Strata merely because Strata consumes its results.

The landing zone publishes a contract describing the resources and access context available to the delivery platform. The contract is standardized at the conceptual level rather than requiring identical vendor-specific names.

```text
Cloud Vendor
    ↓
Landing Zone
    ↓
published vendor-specific contract
    ↓
Delivery
    ↓
Strata
```

A landing-zone contract may expose identifiers, accounts, subscriptions, regions, principals, or other vendor-specific values required by delivery.

The contract does not need to expose the implementation details of the landing zone or its private state.

Likewise, the contract does not inherently constitute a trust relationship. Trust may be established by the landing zone while the corresponding delivery configuration merely consumes the published contract.

Different cloud vendors may therefore have different landing-zone realizations and contract shapes while satisfying the same conceptual delivery requirements.

The landing-zone model is documented separately in `_documentation/landing-zones.md`.

> **Landing zones prepare the cloud; Delivery consumes the prepared cloud.**

# Hosting and Collective

Each promotional stage contains two scopes:

```text
Promotional Stage
├── Hosting
└── Collective
```

Hosting establishes bounded contexts in which applications may be realized.

Collective establishes capabilities and services whose responsibility transcends an individual Hosting environment or has its own meaningful segmentation model.

Collective is a scope within a promotional stage, not a fourth promotional stage.

Each stage has one Collective scope.

Hosting and Collective are separate work streams. Their implementations, source repositories, speculative lifecycles, and promotion decisions may therefore remain independent.

Prospective provides the point at which independently promoted Hosting and Collective artifacts may be explicitly correlated into a component graph.

# Environments

An environment is a bounded hosting context within a Strata Hosting scope.

The current infrastructure realization of an environment is a cloud-provider resource group.

```text
Promotional Stage
    ↓
landing-zone provider boundary
    ↓
Hosting environment
    ↓
resource group
    ↓
logical cluster domains
```

The provider boundary is supplied by the landing zone. Strata consumes that boundary but does not establish the subscription, account, or equivalent vendor container as part of its own lifecycle.

The resource group is an infrastructure realization of the environment boundary; it is not the definition of the Strata concept.

An environment may contain:

* logical cluster domains;
* networking;
* identity integration;
* environment-scoped services;
* policy;
* configuration; and
* other capabilities required by hosted applications.

The number of environments is determined by the requirements of the promotional stage and its delivery model.

An environment is distinct from an application deployment. Applications consume environments; they do not establish the environment boundary.

# Logical Cluster Domains

A logical cluster domain is a Strata-defined hosting boundary for a particular class of workloads.

A Kubernetes cluster or another provider construct may realize the domain, but the provider construct does not define its semantic meaning.

```text
Strata Environment
├── Logical Cluster Domain A
│   └── provider realization
└── Logical Cluster Domain B
    └── provider realization
```

The existence, separation, and purpose of logical cluster domains are therefore part of Strata's jurisdiction.

Application delivery may target an established logical cluster domain but does not establish its Strata meaning.

Logical cluster domains may also exist within Collective when a shared service requires a distinct hosting boundary.

> **Strata defines the logical hosting domain; infrastructure realizes it.**

# Collective

Collective represents shared or cross-environment responsibility within a promotional stage.

It does not constitute a separate jurisdiction and does not require a separate Strata promotional stage.

Collective may contain:

* cloud-provider services;
* managed services;
* shared platform capabilities;
* networking or identity services;
* observability services; and
* in-house services whose responsibility transcends individual environments.

A Collective scope may contain logical cluster domains when shared services require their own hosting boundary.

The distinction is responsibility:

```text
Hosting
    → responsibility bounded to an environment

Collective
    → responsibility shared across environments
      or independently segmented
```

The same infrastructure technology may therefore appear in both scopes while having different semantic responsibilities.

# Promotional Stages

## Speculative

Speculative is the Strata stage for independently realizing and evaluating candidate changes before they become Prospective artifacts.

Hosting and Collective have independent Speculative lifecycles:

```text
Speculative
├── strata-hosting
└── strata-collective
```

Each work stream may produce its own promoted artifact.

Speculative provides candidate realization and validation appropriate to the individual work stream. It does not establish the composition of Hosting and Collective.

Speculative capacity and candidate lifecycle are delivery concerns documented under:

* `promotion/orchestration/capacity.md`
* `promotion/orchestration/events.md`
* `promotion/orchestration/roles.md`
* `promotion/orchestration/workflows.md`

The detailed promotional semantics are defined in [Speculative Promotion](promotion/stages/speculative.md).

Strata may use an accepted Kitting release as a representative consumer workload when validating a proposed hosting change. The Kitting release remains part of Kitting's own promotional lifecycle.

> **Speculative validates independent Strata work streams; it does not compose them.**

## Prospective

Prospective correlates independently promoted Hosting and Collective artifacts into a Strata component graph.

```text
Hosting artifact ─────┐
                      ├──→ Prospective component graph
Collective artifact ──┘
```

The selected artifacts are explicit inputs to the composition.

Prospective validates behavior that crosses the independent lifecycle boundaries, including compatibility, shared contracts, topology assumptions, and representative workload behavior.

The detailed promotional semantics are defined in [Prospective Promotion](promotion/stages/prospective.md).

> **Speculative proves the parts; Prospective proves the composition.**

## Operative

Operative is the Strata stage for establishing the accepted operating realization.

Operative is not defined as a pool of speculative candidate environments.

Its Hosting and Collective realization mechanics, including any internal promotion, replication, traffic management, or live-state transitions, are specific to Operative.

The detailed Operative model remains to be defined.

# Capabilities

A Strata capability is a meaningful outcome established by one or more Strata resources and made available to consumers.

> **Resources establish capabilities; capabilities are what consumers rely upon.**

A capability describes what Strata makes possible rather than how it is implemented.

A capability may depend on multiple resources, and a resource may contribute to multiple capabilities.

Examples include:

* networking;
* workload identity;
* API management;
* runtime hosting;
* deployment;
* observability; and
* shared platform services.

A capability may be realized in Hosting or Collective according to its scope of responsibility.

# Centralized Services

A Strata centralized service is a service intentionally established, configured, and governed by Strata as a shared capability.

A service and the capabilities it provides are distinct concepts.

Centralized services may be implemented through cloud-provider services, managed services, Kubernetes workloads, or combinations of resources.

Examples include:

* API Management;
* identity and authentication;
* observability;
* policy and integration services;
* AI services; and
* document processing.

Consumer-specific configuration does not transfer ownership of the centralized service to the consumer.

Applications consume Collective capabilities through the hosting model while the services remain subject to Strata's delivery lifecycle.

# Hosting and Application Delivery

Strata establishes the hosting model. Application delivery uses that model to deliver workloads.

```text
Strata
├── Hosting
│   └── environments
│       └── logical cluster domains
│           └── application workloads
└── Collective
    └── shared and cross-environment capabilities
```

Application delivery may have its own Speculative, Prospective, and Operative lifecycle.

Those stages do not become additional Strata stages.

The lifecycles are related through consumption and compatibility rather than shared promotional state.

A Kitting promotion does not automatically promote Strata.

A Strata promotion does not automatically promote Kitting.

An application deployment targets a hosting boundary already established by Strata.

> **Strata establishes the hosting domain; application delivery independently promotes workloads within that domain.**

# Delivery Boundary

Delivery establishes and operates the infrastructure required to realize the Strata ontology within cloud boundaries supplied by landing zones.

The implementation mechanisms are deliberately separate from the semantic model.

Conceptually:

```text
Strata ontology
    ↓
semantic boundaries and responsibilities
    ↓
Delivery
    ↓
provider infrastructure within landing-zone boundaries
    ↓
operational delivery machinery
```

Delivery may establish resource groups, environments, logical cluster domains, and baseline capabilities.

It consumes cloud subscriptions, accounts, identities, permissions, and other vendor-specific prerequisites from landing-zone contracts rather than establishing those prerequisites as part of the Strata lifecycle.

The Amiasea API, GitHub workflows, HCP Terraform, and other delivery mechanisms may subsequently operate the established resources.

Those mechanisms do not become Strata resources merely because they participate in Strata delivery.

The orchestration model is documented separately under `promotion/orchestration/`.

> **Landing zones establish cloud context; Delivery establishes the Strata realization within that context.**

# Institutive

Institutive is a separate jurisdiction concerned with establishing the engineering model and its delivery machinery.

Institutive infrastructure may provide capabilities or authority consumed by Strata without becoming part of Strata.

For example, an institutive subscription may contain engineering control-plane infrastructure, credentials, or other machinery used by delivery.

Strata's dependence upon Institutive does not transfer Institutive infrastructure into the Strata hosting jurisdiction.

Cloud-vendor preparation is likewise distinct from Institutive and Strata semantics. A landing zone may establish vendor resources consumed by the Institutive or Strata delivery domains without becoming part of either ontology.

# Ontology Boundary

The Strata ontology separates:

* semantic resources from provider resources;
* resources from capabilities;
* capabilities from implementations;
* jurisdictional boundaries from provider boundaries;
* landing-zone boundaries from Strata boundaries;
* promotional stages from environments;
* environments from logical cluster domains;
* logical cluster domains from workloads;
* Hosting from Collective;
* Strata promotion from application promotion;
* independent Hosting and Collective lifecycles from their later composition;
* consumer workloads from the promotional lifecycle that tests them;
* cloud preparation from delivery; and
* infrastructure establishment from infrastructure operation.

The fundamental structure is:

```text
Cloud Vendor
│
└── Landing Zone
    │
    └── published provider contract
        │
        └── Strata
            │
            ├── Speculative
            │   ├── Hosting
            │   │   └── candidate environments
            │   │       └── logical cluster domains
            │   └── Collective
            │       └── candidate realization
            │
            ├── Prospective
            │   └── component graph
            │       ├── Hosting artifact
            │       └── Collective artifact
            │
            └── Operative
                ├── Hosting
                │   └── accepted operating realization
                └── Collective
                    └── shared capabilities
```

Hosting and Collective remain distinct work streams even when Prospective correlates their artifacts.

Logical cluster domains remain part of Strata's jurisdiction regardless of their provider realization.

Application workloads consume Strata capabilities without becoming part of Strata's hosting ontology.

Landing zones establish vendor-specific prerequisites and publish the context consumed by delivery.

Terraform and the delivery machinery establish and operate the Strata infrastructure without defining the semantic concepts themselves.

> **Landing zones prepare the cloud; Strata defines the hosting domain; Delivery establishes and operates its infrastructure realization.**
