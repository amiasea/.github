# Purpose

Strata exists to establish and govern the **hosting capabilities upon which products can be deployed and operated** within Amiasea.

Strata is not a general-purpose infrastructure organization. It does not provision every resource a provider can create or absorb concerns that belong to products and other domains.

> **Strata provides a coherent, opinionated hosting model within clear jurisdictional boundaries.**

## The Hosting Problem

Products should not need to independently establish the platform concerns required simply to run and operate their workloads.

These concerns commonly include:

* runtime hosting;
* identity;
* networking;
* API exposure;
* security;
* observability; and
* deployment and operational integration.

When each product establishes these concerns independently, the resulting systems become duplicated, inconsistent, and unnecessarily coupled to individual products.

Strata establishes the shared hosting capabilities that belong at the platform level so consumers can use them without reproducing their underlying infrastructure.

## An Opinionated Hosting Model

Strata does not attempt to support every technically possible hosting mechanism.

The fact that something can host software does not make it a Strata capability.

Strata intentionally defines a supported hosting model and establishes the capabilities that belong within it.

> **Strata is domain-agnostic, but it is not implementation-agnostic.**

Strata should remain open to different technologies and implementations while remaining opinionated about the capabilities and operating models it is willing to establish.

## The Consumer Relationship

A consumer presents hosting requirements. Strata determines whether those requirements can be satisfied by the supported hosting model and establishes the capabilities required to satisfy them.

Strata does not prescribe the internal architecture of every consumer. It establishes the capabilities and boundaries within which consumers may be hosted.

The consumer remains responsible for concerns within its own jurisdiction while relying on Strata for concerns that belong to the hosting platform.

## The Desired Outcome

Strata succeeds when products can be hosted without independently rebuilding platform concerns that should be shared, while Strata remains disciplined enough not to become a general-purpose infrastructure authority.

The desired outcome is:

> **A coherent, reusable, opinionated hosting platform with explicit boundaries and well-defined consumer relationships.**

# Principles

Strata is governed by a small set of principles that establish what belongs within its hosting model and how its boundaries should be designed.

## 1. Capability Over Infrastructure

Strata establishes **capabilities**, not inventories of infrastructure.

A resource belongs in Strata because it establishes a capability within the hosting model and within Strata's jurisdiction.

> **The question is not whether Strata can provision it, but what capability it establishes and whether that capability belongs to Strata.**

## 2. Opinionated by Design

Strata intentionally supports a defined hosting model rather than every technically possible approach.

It should prefer coherent, modern, repeatable operating models over arbitrary compatibility with alternative or historical patterns.

> **Technical possibility does not imply architectural legitimacy.**

## 3. Jurisdiction Before Ownership

Strata should determine whether a concern belongs within its jurisdiction before determining how it will be managed.

Ownership follows jurisdiction.

A resource, capability, or service should not enter Strata merely because Strata is capable of managing it.

## 4. Explicit Boundaries

Boundaries should reflect meaningful differences in capability, lifecycle, governance, responsibility, or domain language.

Technical co-location does not imply shared ownership, and technical separation does not necessarily imply a meaningful boundary.

> **A boundary should exist because something meaningful changes across it.**

## 5. Shared Capability, Shared Responsibility

When Strata establishes a capability for multiple consumers, it assumes responsibility for its deliberate establishment, lifecycle, and governance.

Shared consumption alone does not establish Strata responsibility.

## 6. Centralize Deliberately

Centralization is an architectural decision.

A capability should be centralized when a shared service can appropriately serve multiple consumers and its common establishment, lifecycle, or governance belongs within Strata.

Centralization should not be used merely to avoid duplication or because something is technically convenient to share.

## 7. Preserve Consumer Boundaries

Consumers should depend upon Strata capabilities without assuming responsibility for the resources that establish them.

Likewise, Strata should not absorb consumer concerns merely because they are technically coupled to the hosting platform.

Capabilities should therefore be exposed through explicit consumer-facing relationships.

## 8. Design for Evolution

Strata should define its resources and capabilities according to their semantic meaning rather than today's infrastructure topology.

Implementation may change without requiring the hosting model to change.

> **Model the domain boundary, not the current implementation of the boundary.**

## 9. Reject the Catch-All

Strata should not expand simply because a concern is difficult, useful, or technically related to hosting.

When a proposed concern has no clear capability, jurisdiction, consumer relationship, or lifecycle within Strata, it should remain outside the model.

> **Strata's usefulness depends as much upon what it refuses to establish as what it provides.**

# Jurisdiction

Strata's jurisdiction is determined by the capabilities it establishes, the consumers those capabilities serve, and their lifecycle and domain boundaries.

Strata governs the **hosting domain**, not infrastructure in general.

> **Strata owns the capabilities that establish its hosting model, not everything it can technically provision.**

## What Belongs to Strata

A resource or service belongs within Strata when it establishes a capability that is part of the supported hosting model.

Strata may establish that capability through:

* substrate;
* Kubernetes hosting; or
* centralized services.

The underlying technology does not determine jurisdiction. A provider resource may be within Strata when it establishes a Strata capability, while another resource of the same technical kind may belong elsewhere.

## Capability Determines Jurisdiction

The primary question is:

> **What capability does this establish, and does that capability belong to the hosting domain?**

A proposed resource or service should therefore be evaluated by:

1. the capability it establishes;
2. the consumers it serves;
3. its lifecycle;
4. the domain in which it belongs; and
5. whether it should be established centrally or by a consumer.

Infrastructure constructs such as accounts, subscriptions, resource groups, clusters, or managed services have no inherent jurisdiction.

## Shared Services

Strata may establish centralized services when a shared service represents a hosting concern whose establishment, lifecycle, configuration, or governance should be managed centrally.

Multiple consumers are evidence for centralization, but shared consumption alone does not establish jurisdiction.

A product or organizational capability does not become a Strata capability merely because multiple consumers use it.

> **Centralization is an architectural decision; it is not the definition of jurisdiction.**

## Lifecycle and Boundaries

Lifecycle independence is a primary boundary test.

A capability generally belongs to Strata when its purpose and lifecycle are independently governed from an individual product deployment and it establishes a reusable hosting capability.

Conversely, when a resource's purpose and lifecycle are inseparable from a particular product, that is evidence that it belongs to the consumer.

> **The relevant question is not whether something can exist independently, but whether its purpose and lifecycle are independently governed.**

## Hosting Versus Product

Strata establishes the conditions under which products can be hosted. It does not establish the products themselves.

A product may consume Strata capabilities without acquiring jurisdiction over them. Likewise, a product-specific concern does not become a Strata concern merely because Strata provides a mechanism through which it can be deployed.

The technical ability to provision a resource independently is therefore not evidence that consumers should own it.

## Deliberate Boundaries

Strata should not expand its jurisdiction merely because a new technology introduces a new resource type, nor should it inherit infrastructure boundaries simply because providers organize resources that way.

In particular, an environment, account, subscription, cluster, or cloud service is not automatically a Strata boundary.

The boundary must correspond to an actual capability, lifecycle, governance, or domain distinction.

> **Jurisdiction follows meaning, not infrastructure shape.**

## Jurisdictional Test

A proposed Strata resource or service should be capable of answering:

* What capability does it establish?
* Who consumes that capability?
* Which domain owns it?
* What lifecycle governs it?
* Is it part of the supported hosting model?
* Should Strata establish it, or should a consumer establish it?

If these questions cannot be answered clearly, Strata's jurisdiction has not yet been established.

Strata should remain deliberately bounded: capable of establishing the hosting platform without becoming a general-purpose infrastructure authority.

# Federation

Strata operates as a domain within the Amiasea federation.

The federation establishes a coherent architectural model across its domains. Domains retain responsibility for their own concerns while conforming to the principles, constraints, and conventions established at the federal level.

> **Strata is a federated domain, not an independent system.**

## Conformance

Federal principles are intentionally opinionated. They define the architectural space within which domains operate rather than attempting to accommodate every technically possible design.

Strata is expected to incorporate those principles into its own design rather than reinterpret them according to local preference.

Conformance therefore provides consistency across the federation while allowing each domain to develop the model appropriate to its jurisdiction.

## Strata's Domain

Strata is responsible for the hosting domain within the federal model.

It has authority to determine how that domain is modeled and implemented, provided its design remains consistent with federal principles and within its jurisdiction.

> **The federation establishes the common architectural model; Strata establishes the hosting model within it.**

## Opinionated Design

Federation is intentionally opinionated.

A technically possible pattern is not necessarily a supported pattern, and a provider capability does not imply architectural legitimacy.

Federal constraints may therefore be prescriptive or restrictive when necessary to maintain coherence.

Likewise, Strata is expected to make deliberate choices within its own domain rather than attempting to support every possible hosting pattern.

> **Conformance is not the absence of design freedom; it is design freedom within a defined architectural space.**
