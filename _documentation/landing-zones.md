# Landing Zones

Landing Zones establish the cloud-provider context consumed by the Amiasea delivery platform.

A Landing Zone prepares a cloud vendor for use by the platform. It establishes the provider accounts, subscriptions, organizational structures, identities, permissions, federation prerequisites, and other conditions required before Delivery can operate.

Landing Zones are not part of the Delivery lifecycle.

They have a separate responsibility:

```text
Cloud Vendor
    ↓
Landing Zone
    ↓
published contract
    ↓
Delivery
    ↓
platform realization
```

The purpose of Landing Zones is to separate cloud-vendor preparation from the engineering delivery model.

> **Landing Zones prepare the cloud; Delivery consumes the prepared cloud.**

# Purpose

Cloud vendors impose provider-specific initialization requirements that do not belong to the platform's semantic model.

Examples include:

* creating cloud accounts or subscriptions;
* establishing billing relationships;
* establishing provider organizational boundaries;
* creating privileged and institutional identities;
* assigning provider permissions;
* establishing federation prerequisites;
* configuring provider-level policies;
* establishing regions or other provider constraints; and
* preparing the boundaries within which Delivery may operate.

These activities may be performed manually, through infrastructure as code, through provider-native tooling, or through a combination of mechanisms.

The Landing Zone does not prescribe how preparation is performed. Its responsibility is to establish a usable provider context and publish the resulting contract.

# Separation from Delivery

The Landing Zone lifecycle and Delivery lifecycle are related but independent.

```text
Landing Zone lifecycle
    ↓
provider context exists
    ↓
Delivery lifecycle
    ↓
platform resources exist
```

Delivery should not be responsible for creating the cloud context on which its own authority depends.

Likewise, a Landing Zone should not become responsible for the resources and promotional lifecycle of the delivery platform merely because it establishes access to them.

For example, an Azure Landing Zone may establish subscriptions and the identities and permissions required to operate within them. Strata may subsequently consume those subscriptions as hosting boundaries.

The Azure subscription is therefore:

```text
Landing Zone responsibility
        ↓
consumed by
        ↓
Strata responsibility
```

The subscription does not become a Strata resource merely because Strata operates within it.

# Vendor Context

Each Landing Zone publishes a contract describing the provider context available to Delivery.

The contract is standardized around concepts rather than provider-specific resource names.

A contract may describe:

* provider;
* account or subscription;
* region;
* environment boundary;
* institutional identity;
* execution identity;
* client identifier;
* tenant or account identifier;
* resource scope;
* available permissions; and
* other provider-specific values required by Delivery.

The contract does not need to normalize the underlying provider representation.

For example:

```text
Azure

    subscription_id
    tenant_id
    client_id

AWS

    account_id
    role_arn
    region
```

These values do not need to have identical meanings or naming conventions.

The important property is that each vendor contract provides the information required for a Delivery implementation to consume that Landing Zone.

> **Contracts standardize concepts, not provider implementations.**

# Provider-Specific Contracts

A Delivery implementation explicitly selects the vendor-specific contract appropriate to its Landing Zone.

The contract acts as an interface between the Landing Zone and Delivery without requiring the underlying provider configurations to be identical.

For example:

```text
Strata
    │
    ├── Azure contract
    │       └── Azure Landing Zone
    │
    └── AWS contract
            └── AWS Landing Zone
```

GCP may provide another contract when supported:

```text
Strata
    │
    ├── Azure contract
    ├── AWS contract
    └── GCP contract
```

The Strata ontology remains vendor-independent.

The contract consumed by its implementation is vendor-specific.

This allows Strata to describe the same semantic hosting model while allowing each provider to realize it according to its own infrastructure model.

# Published Contract

The published contract is the Delivery-facing representation of the Landing Zone.

It does not need to expose the private state of the Landing Zone.

The Landing Zone may maintain whatever internal state is necessary to establish and manage the provider environment. Delivery only needs the resulting values required to consume that environment.

Conceptually:

```text
Landing Zone
    │
    ├── provider preparation
    ├── identities
    ├── permissions
    └── provider scope
            ↓
        publication
            ↓
    published contract
            ↓
        Delivery
```

Publication is an integration ceremony. It does not require Landing Zone and Delivery to share Terraform state.

A published contract may be represented through:

* HCP Terraform variable sets;
* workspace variables;
* stack variables;
* repository configuration;
* provider configuration;
* generated artifacts; or
* another explicit delivery interface.

The mechanism is subordinate to the contract.

The Delivery platform should consume the published context rather than discover, reconstruct, or independently establish the provider environment.

# Contract Publication

Publishing a Landing Zone contract is a deliberate ceremony.

The ceremony takes the provider context established by the Landing Zone and makes the required values available to the Delivery platform.

Conceptually:

```text
Provider preparation
        ↓
contract values
        ↓
publication ceremony
        ↓
Delivery interfaces
        ↓
Delivery workspaces and stacks
```

The publication mechanism may populate an HCP Terraform variable set shared by the appropriate Delivery workspaces or stacks.

This establishes a stable Delivery-facing boundary without requiring one Delivery workspace to depend on another workspace merely to obtain provider context.

In particular, provider context should not be unnecessarily propagated through `terraform_remote_state` or `tfe_outputs` when the values constitute a Landing Zone contract rather than outputs of the Delivery lifecycle.

# Trust

Trust relationships are not inherently part of the published contract.

A Landing Zone may establish the trust required for Delivery to authenticate to the cloud provider.

For example, an Azure Landing Zone may establish a federated identity credential whose claims are known in advance.

The Landing Zone does not need to derive that claim from Delivery state.

It may instead establish the trust relationship from a standardized Delivery convention:

```text
Known Delivery identity
        ↓
known OIDC claims
        ↓
Landing Zone trust configuration
```

Delivery may subsequently receive the corresponding identity information through the published contract.

Trust establishment and contract publication therefore remain separate concerns even though they participate in the same overall system.

The Landing Zone may know:

* which Delivery identity is trusted;
* which issuer is trusted;
* which audience is trusted;
* which claims are accepted; and
* which provider scope that identity may access.

The published contract may contain only the information Delivery needs to use that trust.

> **A contract describes what Delivery may consume; it does not need to describe how the Landing Zone established that trust.**

# Permissions

The Landing Zone establishes the provider-side permissions required for Delivery.

Permissions are defined according to the provider's access model.

The Landing Zone may therefore establish different permission structures for different vendors while exposing equivalent Delivery concepts.

For example:

```text
Azure

    identity → subscription/resource scope

AWS

    role → account/resource scope
```

Delivery should not recreate or reinterpret the provider's permission model.

Instead, it consumes an already-authorized provider context.

The Landing Zone therefore owns the question:

> What may this Delivery identity do within this provider environment?

Delivery owns the question:

> What infrastructure should be established using the authority provided to it?

Permissions may be intentionally different for different Delivery contexts.

For example, an identity used by Institutive execution may have access to a sovereign Key Vault, while an identity used by Speculative execution may have Contributor access to a speculative subscription.

The Landing Zone establishes those permissions; Delivery consumes them.

# Identity

Landing Zones may establish identities used by institutional Delivery.

These identities are not application identities merely because they are used by Terraform, HCP Terraform, GitHub, or another automation mechanism.

They represent institutional access to the provider environment.

The identity's home, lifecycle, and permissions therefore belong to the Landing Zone's provider preparation model.

Delivery consumes the identity rather than defining its institutional existence.

For example, an Azure Entra application such as Amiasea-Authority may be established by the Landing Zone and subsequently trusted by HCP Terraform through federated identity credentials.

The Landing Zone owns the existence and provider-side authorization of that identity.

Delivery consumes the resulting authority.

# Scope

The Landing Zone establishes the provider scope within which Delivery operates.

Scope may include:

* an Azure subscription;
* an AWS account;
* a provider organizational unit;
* a resource hierarchy;
* a region; or
* another vendor-specific boundary.

The scope itself does not define the semantic role assigned to it by Delivery.

For example, an Azure subscription may be published as available Speculative capacity.

The Landing Zone establishes the subscription.

Strata determines that the subscription is used as the infrastructure realization of its Speculative hosting boundary.

```text
Landing Zone
    └── Azure subscription
            ↓
Delivery contract
            ↓
Strata
    └── Speculative hosting boundary
```

The same distinction applies to Prospective and Operative infrastructure.

The Landing Zone provides the provider boundary. Delivery determines what that boundary means within its own ontology.

# Lifecycle

Landing Zones have their own lifecycle.

A Landing Zone may be created before the Delivery platform exists, modified independently of Delivery, or maintained for the lifetime of the cloud environment.

Delivery may consume a Landing Zone contract only after the required provider context exists.

Changes to the Landing Zone contract therefore change the available infrastructure context without constituting changes to the Strata promotional lifecycle.

For example:

```text
Landing Zone

    establish subscription
        ↓
    establish identity
        ↓
    establish permissions
        ↓
    establish trust
        ↓
    publish contract

Delivery

    consume contract
        ↓
    establish platform infrastructure
        ↓
    promote platform changes
```

The two sequences may depend on one another without being one lifecycle.

# Landing-Zones Repository

The `landing-zones` repository provides a common home for Landing Zone definitions, provider-specific preparation, and contract publication.

The repository is not required to implement every Landing Zone entirely through Terraform.

It provides an organizational boundary for the Landing Zone ceremony regardless of whether a particular preparation step is automated.

A Landing Zone implementation may therefore contain:

```text
landing-zones

├── Azure
├── AWS
└── GCP
```

The exact repository structure is implementation-specific.

The important boundary is that cloud-vendor preparation is located here rather than inside Delivery repositories.

# Contract Consumers

A Landing Zone contract is consumed explicitly by the Delivery implementation that requires it.

For example, a Strata implementation may consume:

```text
Azure Speculative Landing Zone
Azure Prospective Landing Zone
Azure Operative Landing Zone
```

while an AWS implementation may consume corresponding AWS Landing Zone contracts.

The semantic role of the infrastructure is determined by the consumer.

The Landing Zone provides provider context; the consumer assigns that context to its own domain.

This permits the same Landing Zone design to support multiple Delivery domains without embedding Strata-specific semantics into the cloud preparation layer.

# Boundary

Landing Zones establish:

* provider accounts and subscriptions;
* provider organizational structures;
* billing relationships;
* institutional identities;
* provider permissions;
* federation prerequisites;
* provider-level policies;
* provider-specific infrastructure prerequisites; and
* the published provider contract.

Landing Zones do not establish:

* Strata promotional stages;
* Strata environments;
* logical cluster domains;
* Collective capabilities;
* application workloads;
* application promotion;
* Strata resource semantics; or
* the operational lifecycle of the Delivery platform.

Delivery consumes the Landing Zone and establishes those concerns within its own jurisdiction.

# Design Principle

The Landing Zone exists because cloud-vendor preparation and engineering Delivery are different kinds of work.

Cloud vendors require provider-specific preparation.

Amiasea requires a vendor-independent engineering Delivery model.

Trying to make one lifecycle perform both responsibilities introduces unnecessary coupling, artificial dependencies, and confusing ownership boundaries.

The Landing Zone boundary allows each system to remain coherent:

```text
Cloud Vendor
    │
    └── Landing Zone
            │
            ├── provider preparation
            ├── institutional access
            ├── trust
            ├── permissions
            └── published contract
                    │
                    ↓
                Delivery
                    │
                    ├── Strata
                    ├── Kitting
                    └── other delivery domains
```

> **Landing Zones prepare and publish provider context. Delivery consumes that context to establish the engineering platform.**
