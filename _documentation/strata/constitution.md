# Strata Constitution

Strata establishes and governs the hosting capabilities upon which products can be deployed and operated within Amiasea.

Strata is a federated hosting domain, not a general-purpose infrastructure authority. It establishes an opinionated hosting model and the capabilities required to realize that model while preserving clear boundaries between hosting, products, and other Amiasea domains.

> **Strata provides a coherent, opinionated hosting model within explicit jurisdictional boundaries.**

# Purpose

Products should not need to independently establish the platform concerns required simply to run and operate their workloads.

These concerns may include:

* runtime hosting;
* identity and trust;
* networking;
* API exposure;
* security;
* observability; and
* deployment and operational integration.

Strata establishes the hosting capabilities that belong at the platform level so consumers can use them without reproducing their underlying infrastructure.

Strata is successful when products can consume a coherent hosting model without requiring each product to independently establish the same platform concerns.

# Hosting Model

Strata does not attempt to support every technically possible hosting mechanism.

The existence of a provider resource, platform technology, or deployment pattern does not make it a Strata capability.

Strata deliberately defines the hosting model it is willing to establish and operate.

> **Strata is domain-agnostic, but it is not implementation-agnostic.**

Strata should remain open to changes in technology and implementation while remaining opinionated about the capabilities and operating models that constitute its supported hosting model.

# Principles

## 1. Capability Over Infrastructure

Strata establishes capabilities, not inventories of infrastructure.

A resource belongs in Strata because it establishes a capability within the hosting model and within Strata's jurisdiction.

> **The question is not whether Strata can provision it, but what capability it establishes and whether that capability belongs to Strata.**

## 2. Opinionated by Design

Strata intentionally supports a defined hosting model rather than every technically possible approach.

Technical possibility does not imply architectural legitimacy.

Strata should prefer coherent, repeatable, and deliberately supported operating models over arbitrary compatibility with alternative patterns.

## 3. Jurisdiction Before Ownership

Strata determines whether a concern belongs within its jurisdiction before determining how that concern should be managed.

Ownership follows jurisdiction.

A resource, capability, or service should not enter Strata merely because Strata is capable of managing it.

## 4. Explicit Boundaries

Boundaries should correspond to meaningful differences in capability, lifecycle, governance, responsibility, or domain language.

Technical co-location does not imply shared ownership, and technical separation does not necessarily establish a meaningful boundary.

> **A boundary exists because something meaningful changes across it.**

## 5. Shared Capability, Shared Responsibility

When Strata establishes a capability for multiple consumers, it assumes responsibility for its deliberate establishment, lifecycle, and governance.

Shared consumption alone does not establish Strata responsibility.

## 6. Centralize Deliberately

Centralization is an architectural decision.

A capability should be centralized when its common establishment, lifecycle, configuration, or governance appropriately belongs within Strata.

Centralization should not be used merely to avoid duplication or because something is technically convenient to share.

## 7. Preserve Consumer Boundaries

Consumers should depend upon Strata capabilities without assuming responsibility for the infrastructure that establishes them.

Likewise, Strata should not absorb consumer concerns merely because they are technically coupled to the hosting platform.

Capabilities should therefore be exposed through explicit relationships between Strata and its consumers.

## 8. Model Meaning, Not Topology

Strata resources and capabilities should be defined according to their semantic meaning rather than the infrastructure topology used to implement them.

An account, subscription, resource group, cluster, workspace, or managed service is not inherently a Strata boundary.

Implementation may change without requiring the hosting model to change.

> **Model the domain boundary, not the current implementation of the boundary.**

## 9. Preserve Lifecycle Independence

Lifecycle independence is a primary boundary test.

A capability generally belongs within Strata when its purpose and lifecycle are independently governed from an individual consumer and it establishes a reusable hosting capability.

When a resource's purpose and lifecycle are inseparable from a particular product or consumer, that is evidence that the resource belongs to that consumer instead.

> **The relevant question is whether purpose and lifecycle are independently governed, not merely whether infrastructure can exist independently.**

## 10. Reject the Catch-All

Strata should not expand simply because a concern is useful, difficult, or technically related to hosting.

When a proposed concern has no clear capability, jurisdiction, consumer relationship, or lifecycle within Strata, it should remain outside the model.

> **Strata's usefulness depends as much upon what it refuses to establish as what it provides.**

# Jurisdiction

Strata governs the hosting domain within Amiasea.

Its jurisdiction is established by the capabilities it provides, the consumers those capabilities serve, and the lifecycle and domain boundaries associated with those capabilities.

> **Strata owns the capabilities that establish its hosting model, not everything it can technically provision.**

## Capability Determines Jurisdiction

The primary question is:

> **What capability does this establish, and does that capability belong to the hosting domain?**

A proposed resource or service should therefore be evaluated by:

1. the capability it establishes;
2. the consumers it serves;
3. its lifecycle;
4. the domain in which it belongs; and
5. whether it should be established centrally or by a consumer.

Infrastructure constructs have no inherent jurisdiction.

A provider may expose accounts, subscriptions, resource groups, clusters, networks, managed services, and other constructs, but provider taxonomy does not determine Strata jurisdiction.

## Hosting Versus Product

Strata establishes the conditions under which products can be hosted. It does not establish the products themselves.

A product may consume Strata capabilities without acquiring jurisdiction over them.

Likewise, a product-specific concern does not become a Strata concern merely because Strata provides a mechanism through which that concern can be deployed.

> **Technical coupling does not establish jurisdiction.**

## Deliberate Boundaries

Strata should not expand its jurisdiction merely because a new technology introduces a new resource type.

Nor should Strata inherit infrastructure boundaries simply because providers organize resources that way.

An environment, account, subscription, cluster, workspace, or cloud service becomes meaningful to Strata only when it corresponds to an actual capability, lifecycle, governance, or domain distinction.

> **Jurisdiction follows meaning, not infrastructure shape.**

## Jurisdictional Test

A proposed Strata capability should be able to answer:

* What capability does it establish?
* Who consumes that capability?
* Which domain governs it?
* What lifecycle governs it?
* Is it part of the supported hosting model?
* Should Strata establish it, or should a consumer establish it?

If these questions cannot be answered clearly, Strata's jurisdiction has not yet been established.

# Strata Delivery

Strata capabilities are developed and advanced through independently governed work streams.

The initial Strata model separates Hosting and Collective as distinct work streams:

```text
strata-hosting
strata-collective
```

Their implementation and promotional lifecycles remain independent even when their resulting artifacts are eventually composed.

Strata promotion therefore distinguishes between validating an individual lifecycle and validating a composition of independently promoted lifecycles.

The promotional model consists of:

```text
Speculative
    ↓
Prospective
    ↓
Operative
```

## Speculative

Speculative establishes confidence in an individual Strata lifecycle.

Hosting and Collective may independently progress through Speculative and produce independently promotable artifacts.

```text
Hosting
    ↓
Speculative
    ↓
Hosting artifact

Collective
    ↓
Speculative
    ↓
Collective artifact
```

Speculative does not establish the validity of a Hosting/Collective composition.

## Prospective

Prospective deliberately selects independently promoted artifacts and validates them as a composition.

```text
Hosting artifact ─────┐
                      ├──→ Prospective component graph
Collective artifact ──┘
```

The selected versions are part of the composition being evaluated.

A later promotion of one component does not silently alter an existing Prospective composition.

> **Speculative proves the parts; Prospective proves the composition.**

## Operative

Operative represents the subsequent promotion of a validated Strata composition into its operational context.

Its detailed semantics remain defined separately from this constitution.

The existence of the stage does not imply that its implementation or orchestration is fixed by this document.

# Hosting and Collective

Hosting and Collective represent distinct Strata responsibilities and lifecycles.

They may share infrastructure, delivery machinery, or validation mechanisms where appropriate without becoming one lifecycle.

Their independence is preserved through:

* independent source;
* independent promotional state;
* independent artifacts;
* explicit version selection; and
* explicit composition.

Technical centralization therefore does not imply semantic unification.

```text
Hosting lifecycle ───────┐
                         ├──→ explicit composition
Collective lifecycle ────┘
```

# Delivery Machinery

Strata promotion is supported by Amiasea delivery machinery.

The machinery coordinates events, platform state, capacity, reservations, execution, and other responsibilities required to advance the promotional lifecycle.

These mechanisms do not redefine Strata semantics.

The Amiasea API provides the primary platform control-plane boundary through which this machinery is currently implemented.

GitHub provides source control, governance, workflow execution, and event emission.

HCP Terraform provides Terraform workspace execution and state management.

GitHub and HCP Terraform remain authoritative for the concerns they own.

```text
GitHub ──────────────┐
                    │
HCP Terraform ──────┤
                    ▼
              Amiasea API
                    │
                    ▼
             delivery machinery
                    │
                    ▼
             execution systems
```

The delivery machinery therefore operates Strata without becoming the semantic authority for Strata.

# Federation

Strata operates as a domain within the Amiasea federation.

The federation establishes a coherent architectural model across domains. Domains retain responsibility for their own concerns while conforming to the principles, constraints, and conventions established at the federal level.

> **Strata is a federated domain, not an independent system.**

## Conformance

Federal principles define the architectural space within which domains operate.

Strata is expected to incorporate those principles into its own design rather than reinterpret them according to local preference.

Conformance provides consistency across the federation while allowing Strata to develop the hosting model appropriate to its jurisdiction.

## Strata's Authority

Strata has authority over the hosting domain within the federal model.

It may determine how that domain is modeled and implemented provided its design remains consistent with federal principles and within its jurisdiction.

> **The federation establishes the common architectural model; Strata establishes the hosting model within it.**

## Opinionated Federation

Federation is intentionally opinionated.

A technically possible pattern is not necessarily a supported pattern, and a provider capability does not imply architectural legitimacy.

Federal constraints may therefore be prescriptive where necessary to maintain coherence.

Likewise, Strata is expected to make deliberate choices within its own domain rather than attempting to support every possible hosting pattern.

> **Conformance is design freedom within a defined architectural space.**

# Consumer Relationship

A consumer presents hosting requirements.

Strata determines whether those requirements can be satisfied by the supported hosting model and establishes the capabilities required to satisfy them.

The consumer remains responsible for concerns within its own jurisdiction while relying on Strata for concerns that belong to the hosting platform.

Strata should therefore expose capabilities through explicit relationships rather than requiring consumers to understand or manage the infrastructure that realizes those capabilities.

# Desired Outcome

Strata succeeds when products can consume a coherent hosting model without independently rebuilding platform concerns that should be shared, while Strata remains disciplined enough not to become a general-purpose infrastructure authority.

The desired outcome is:

> **A coherent, reusable, opinionated hosting platform with explicit jurisdiction, independently governed lifecycles, deliberate composition, and well-defined consumer relationships.**
