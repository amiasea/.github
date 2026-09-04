# Taxonomy

The Amiasea taxonomy distinguishes concepts by the responsibility and context they describe. The names are related by meaning and progression, but they do not constitute a single linear lifecycle.

## Primitive

A **primitive** is a fundamental capability at the level where that capability itself is being established.

Primitive is relative to the level of abstraction.

For example, if the platform responsible for establishing a Key Vault is being developed, the Key Vault capability may be considered a primitive of that platform. Once the Key Vault is established, however, it may serve as an imperative capability to an engineering model that consumes it.

Primitive therefore describes a fundamental capability **as it is being established**, rather than prescribing the semantic role it has for every consumer.

A primitive may subsequently realize an imperative, an Institutive capability, or another responsibility depending upon the context in which it is established and consumed.

## Imperative

An **imperative** is an established prerequisite capability upon which another context may depend.

Imperative does not describe a stage in an engineering-model lifecycle. It describes a contextual relationship: something is imperative **to** another context because that context depends upon it.

**Amiasea Imperative** provides the quintessential capabilities required to establish and exercise authority for the Amiasea engineering model.

These capabilities may also be consumed by other contexts where their responsibility is applicable.

Examples include:

* workload identity and service principals;
* federated identity credentials and external trust relationships;
* the Amiasea GitHub App and its associated installation authority;
* platform-level key custody;
* Key Vaults containing platform-level keys and credentials;
* other capabilities required to establish or exercise authority.

The **Amiasea GitHub App** is a particularly clear example of an imperative capability.

The engineering model may depend upon the GitHub App to exercise GitHub authority, but the GitHub App is not itself an artifact produced by the Amiasea engineering model. Its responsibility is to provide an authority that the engineering model can depend upon.

Consequently, even if the underlying provider eventually exposes a Terraform resource capable of creating a GitHub App, that resource belongs to the **Imperative workstream** rather than to the Amiasea engineering model's Strata or Kitting delivery.

The provider resource is an implementation mechanism. It does not determine the semantic ownership of the capability being established.

Likewise, a platform-level Key Vault is imperative when its responsibility is to provide the key custody and credentials upon which the engineering model's authority and automation depend.

The fact that the engineering model may subsequently use secrets or keys does not make the platform-level Key Vault Institutive.

The existence of an imperative does not imply that every engineering model must consume it, nor does an imperative belong to the engineering model merely because the engineering model uses it.

An imperative may therefore be established specifically to support one engineering model while still providing capabilities whose responsibility extends beyond that model.

### Imperative Workstream

Imperative may itself have a workstream.

The Imperative workstream is **not a delivery stage of the Amiasea engineering model**. It is the workstream responsible for establishing and maintaining the imperative capabilities upon which the engineering model depends.

It may use the same primitive engineering constructs used elsewhere in Amiasea—repositories, branches, workflows, Terraform workspaces, Terraform state, and provider resources—without becoming an artifact of the engineering model.

For example, the Imperative workstream may be implemented as:

```text
amiasea-imperative repository
    │
    ├── development
    └── main
         │
         ▼
amiasea-imperative workspace
    │
    └── VCS-backed

```

There is no requirement for this workstream to pass through Strata, Kitting, speculative capacity, prospective promotion, or operative promotion.

Its purpose is simply to establish and maintain the capabilities that must exist for autonomous engineering delivery to operate.

The workstream may therefore establish capabilities such as:

* the Amiasea GitHub App;
* platform-level key custody;
* the Amiasea workload identity;
* federated identity credentials and associated trust relationships;
* the `amiasea-institutive` subscription and resource group;
* required billing segmentation; and
* other minimum capabilities required for autonomous engineering delivery.

The simplicity of this workstream is intentional. Imperative exists to establish the conditions for autonomous engineering, not to become an additional delivery lifecycle through which every imperative capability must be promoted.

The distinction is therefore:

```text
Imperative workstream
    │
    ├── establishes GitHub App
    ├── establishes identity
    ├── establishes trust
    ├── establishes key custody
    └── establishes prerequisites
              │
              ▼
       Amiasea engineering model

```

The Imperative workstream may be implemented using the same engineering primitives as the engineering model without itself being an artifact **of** that engineering model.

### Jurisdictional Instigation

The authority that establishes the existence and jurisdiction of Amiasea Imperative exists prior to the automation that operates within that jurisdiction.

The Imperative workstream therefore does not constitute the ultimate jurisdictional instigator. It operates within authority that has already been established for it.

Amiasea Imperative does not recursively establish another `amiasea-imperative` in another provider context as an extension of its own jurisdiction.

For example:

```text
jurisdictional instigation
          │
          ▼
amiasea-imperative
          │
          ├── establishes imperative primitives
          │
          ├── establishes amiasea-institutive
          │
          └── enables autonomous engineering

```

The authority that instigates this structure is external to the structure being established.

This boundary is fundamental to the architecture. Imperative may establish the prerequisites for autonomous engineering, but it does not become the ultimate source of the jurisdiction within which those prerequisites are established.

Consequently, an eventual multi-cloud engineering model may realize different semantic contexts in different providers without requiring one provider's Imperative context to recursively establish an equivalent Imperative context in another provider.

The semantic model remains Amiasea. Provider-specific contexts are realizations of that model under their respective authorities and responsibilities.

## Automation Prerequisite

Imperative capabilities establish the conditions under which automation can exist.

Automation cannot establish the imperative capabilities upon which that same automation depends. The initial establishment of Imperative therefore necessarily occurs through an authority that exists outside the automation being bootstrapped.

Conceptually:

```text
external bootstrap authority

            │

            ▼

     imperative bootstrap

            │

      ┌─────┼─────┐

      ▼     ▼     ▼

   identity federation key custody

      │     │     │

      └─────┼─────┘

            ▼

   automation becomes possible

```

The bootstrap authority may establish the initial App Registrations, service principals, federated identity credentials, GitHub App, Key Vaults, keys, and permissions required for subsequent automated establishment.

Once those capabilities and their required trust relationships exist, automation can assume responsibility for establishing contexts that consume them.

The important boundary is therefore not merely whether a resource was created manually or automatically. The boundary is whether the capabilities required for the automation itself have already been established.

## Bootstrap Handoff

A bootstrap ceremony establishes the minimum imperative capabilities and trust relationships required for autonomous engineering delivery.

The ceremony reaches its architectural handoff when subsequent establishment can be performed by the established automation authority without requiring the original bootstrap authority.

Conceptually:

```text
bootstrap authority
        │
        ▼
    Imperative
        │
        │ establishes authority and trust
        ▼
 federated automation
        │
        ▼
    Institutive
        │
        ▼
engineering delivery

```

Imperative therefore precedes automation **as a dependency**, not as a lifecycle stage of the engineering model.

The bootstrap ceremony is not defined by manual execution. Imperative resources may themselves be established through a workstream and automation once the authority required to operate that automation exists.

The invariant is that the authority required to establish the automation's prerequisites cannot itself depend upon the automation whose prerequisites it is establishing.

## Institutive

**Institutive** describes the context in which an engineering model is established and maintained.

Institutive is not itself a prerequisite that is logically required for an engineering model to exist. An engineering model could be established without a distinct Institutive context.

In practice, a coherent engineering model naturally benefits from an existential context in which its infrastructure, delivery mechanisms, and associated systems can be established and maintained. That context is Institutive.

An Institutive context therefore belongs to a particular engineering model.

For Amiasea:

```text
Amiasea Enterprise
└── amiasea namespace
    │
    ├── imperative
    │
    └── amiasea
        └── engineering model
            └── amiasea-institutive

```

`amiasea-institutive` is the Institutive context of the Amiasea engineering model.

The existence of `amiasea-institutive` does not imply that every engineering model requires an Institutive context, nor does it imply that Amiasea requires multiple Institutive contexts.

A different engineering model may establish its own Institutive context if its architecture requires one. This is a consequence of that model's context, not a requirement imposed by the existence of Amiasea Imperative.

Institutive also does not imply that every artifact associated with the engineering model must forever be produced within the same repository, workspace, or delivery mechanism.

As the engineering model matures, capabilities that were initially developed together within its Institutive context may acquire sufficiently independent responsibilities to become independently versioned and independently kit artifacts.

This is an **evolution of the engineering model**, not the disappearance of Institutive.

### Institutive Key Custody

Institutive infrastructure may itself contain capabilities that resemble imperative infrastructure without becoming Imperative.

For example, `amiasea-institutive` may have its own Key Vault for secrets, certificates, encryption keys, or other capabilities that are valid specifically within the context of the Amiasea engineering model.

That Key Vault is Institutive because of the responsibility it realizes.

It is distinct from the platform-level Key Vault established by Amiasea Imperative:

```text
amiasea-imperative
    │
    └── platform-level Key Vault
        └── capabilities required to establish/exercise authority

amiasea-institutive
    │
    └── Institutive Key Vault
        └── capabilities required within the engineering model

```

The presence of a Key Vault therefore does not determine whether something is Imperative or Institutive.

Its semantic role is determined by **what responsibility the Key Vault realizes and which context owns that responsibility**.

## Existential Context

An Institutive context is an **existential context** for its engineering model.

For Amiasea, this means that `amiasea-institutive` represents the environment in which the Amiasea engineering model exists as an established delivery context.

It is not divided into separate development and production Institutive environments merely because the engineering model has development, prerelease, or release activity.

Branches, release candidates, and promotion positions do not create additional existential Institutive contexts.

The existence of `amiasea-institutive` is therefore a contextual choice for the Amiasea engineering model, not a universal requirement for engineering models in general.

The fact that Amiasea Imperative establishes capabilities required by Amiasea Institutive does not imply that those capabilities become part of Institutive itself.

Likewise, the existence of an Institutive Key Vault does not imply that platform-level key custody must move into Institutive.

The two contexts may each contain infrastructure that uses the same provider primitives while realizing different semantic responsibilities.

## Speculative

**Speculative** describes candidate realization within an engineering model.

Speculative concerns changes that are being explored and evaluated before becoming prospective.

A speculative realization is not itself a separate engineering model or existential context. It is a position within the delivery model established by Institutive.

## Prospective

**Prospective** describes intended realization that has been selected for advancement but has not yet become operative.

Prospective represents the state of an engineering model's intended future realization.

It is distinct from both speculative exploration and operative realization.

## Operative

**Operative** describes realization that is established as the currently intended operational state.

Operative is concerned with the engineering model's realized operational responsibility rather than with candidate evaluation or future composition.

## The Relationship

The concepts can be understood as follows:

```text
Amiasea Enterprise
└── amiasea namespace
    │
    ├── imperative
    │   │
    │   └── imperative workstream
    │       ├── GitHub App
    │       ├── identity
    │       ├── trust
    │       ├── key custody
    │       └── other prerequisites
    │
    └── amiasea
        │
        └── engineering model
            │
            └── amiasea-institutive
                │
                ├── Speculative
                ├── Prospective
                └── Operative

```

This diagram does not represent a single lifecycle from Imperative through Operative.

Instead:

* **Primitive** describes a fundamental capability at the level where it is established.
* **Imperative** describes an established prerequisite relationship.
* **Imperative workstream** establishes and maintains imperative capabilities but is not itself an artifact of the engineering model.
* **Institutive** describes the existential context of an engineering model.
* **Speculative**, **Prospective**, and **Operative** describe positions within the realization and delivery of that engineering model.
* **Uroboros** describes the recursive closure of the engineering model as a whole.

The `-tive` terminology therefore provides a useful conceptual progression without requiring the terms to be members of one strictly ordered lifecycle.

## Infrastructure and Semantic Role

Infrastructure constructs do not acquire their semantic meaning merely from their provider type.

A subscription, resource group, Key Vault, service principal, Terraform workspace, repository, service, or other infrastructure construct may realize a concept without defining the concept itself.

For example:

```text
amiasea-imperative
    └── rg-amiasea-imperative
          └── platform-level Key Vault

```

The Key Vault's semantic role is determined by the responsibility it realizes: it is imperative because it provides capabilities required by contexts that depend upon it.

Likewise:

```text
amiasea-institutive
    └── rg-amiasea-institutive
          └── Institutive Key Vault

```

This Key Vault is Institutive when its responsibility is confined to the context of the Amiasea engineering model.

The two Key Vaults may be technically similar while being semantically different.

Likewise, a GitHub App may be represented by a provider-specific resource but remain an Imperative primitive because its responsibility is to establish authority required by the engineering model.

The implementation mechanism does not determine the taxonomy.

The same provider construct may therefore have different semantic roles in different contexts. A subscription is not inherently Imperative or Institutive; a Key Vault is not inherently Imperative or Institutive; and a repository or Terraform workspace is not inherently part of Strata or Kitting.

Meaning derives from the responsibility the construct realizes.

## Contextual Independence

Imperative and Institutive exist at different contextual levels.

Amiasea Imperative establishes the quintessential prerequisite capabilities required by the Amiasea engineering model. Some of those capabilities may also be useful or applicable to other contexts.

Conceptually:

```text
                  Amiasea Enterprise
                         │
                  amiasea namespace
                         │
              ┌──────────┴──────────┐
              │                     │
         imperative              amiasea
              │                     │
     imperative workstream    engineering model
              │                     │
       prerequisites          amiasea-institutive
                                    │
                           engineering delivery

```

An Institutive context, by contrast, establishes the context of one particular engineering model.

Consequently, `amiasea-institutive` is not the contextual successor to `amiasea-imperative`. It is a context that depends upon capabilities provided by Amiasea Imperative.

The relationship is dependency, not inheritance:

```text
Imperative
    │
    │ provides prerequisite capabilities
    ▼
Institutive
    │
    │ establishes an engineering model
    ▼
Speculative / Prospective / Operative

```

The vertical representation is useful for understanding dependency and progression, but the concepts remain semantically distinct.

The Imperative workstream and the Amiasea engineering model may both use repositories, workflows, Terraform workspaces, Terraform state, identities, and provider resources. Their use of the same primitive types does not make them part of the same delivery system.

In particular, the Imperative workstream does not become subject to the Strata and Kitting promotion model merely because Strata and Kitting use the same underlying engineering primitives.

The existence of Amiasea Imperative does not establish a requirement for multiple Institutive contexts.

Likewise, the existence of Amiasea Imperative does not establish a requirement for another Imperative context in another cloud. A multi-cloud engineering model may assign different provider realizations to different semantic contexts without extending the jurisdiction of Amiasea Imperative itself.

## Bootstrap and Delivery

The distinction between Imperative and Institutive also establishes a boundary in the delivery architecture.

Imperative must exist sufficiently for automation to authenticate, establish authority, and obtain access to the capabilities required for subsequent delivery.

Institutive delivery may then use that established authority to establish and maintain the Amiasea engineering model.

This means the initial bootstrap cannot be completely self-hosting:

```text
Imperative bootstrap

        │

        │ establishes identity,

        │ trust, key custody,

        │ and authority

        ▼

automation

        │

        ▼

Institutive delivery

        │

        ├── infrastructure

        ├── delivery mechanisms

        ├── engineering services

        └── engineering-model capabilities

```

The bootstrap ceremony is therefore a transition from externally established authority to autonomous engineering delivery.

Once the transition has occurred, ordinary Institutive delivery should not require the original bootstrap authority merely to authenticate or establish the resources for which the automation has been entrusted.

The Imperative workstream may continue to exist and maintain imperative capabilities, but it remains semantically separate from the delivery lifecycle of the engineering model.

This does not mean that every imperative must be created manually, nor that every Imperative resource must be created in a single ceremony. It means that the authority required to establish the automation's prerequisites cannot itself depend upon the automation whose prerequisites it is establishing.

## Uroboros

**Uroboros** describes the intended end condition of the Amiasea engineering model: an engineering system whose own artifacts become capable of establishing and maintaining the engineering system in which those artifacts exist.

Uroboros is not another `-tive` category. It describes the **completion and recursive closure of the engineering model as a whole**.

The objective is not for Amiasea to become independent of all external reality. The objective is for the engineering model to become sufficiently established that its own artifacts, authorities, delivery mechanisms, and runtimes can participate in establishing and maintaining the system itself.

The Uroboros form of Amiasea should therefore be understood separately from the Imperative workstream.

The Imperative workstream may have its own repository, branches, workflows, Terraform workspace, and Terraform state. Those are mechanisms through which imperative capabilities are established and maintained.

They do not make the Imperative workstream an artifact produced by the Amiasea engineering model.

Likewise, the Amiasea engineering model itself is not an artifact produced by the engineering model.

Rather, the engineering model may eventually produce artifacts that provide the mechanisms through which the engineering model can establish and maintain itself.

### Evolution of the Engineering Model

The recursive closure described by Uroboros does not imply that the engineering model remains architecturally static while becoming self-maintaining.

On the contrary, a mature engineering model should be capable of **evolving its own structure**.

Early in its existence, multiple capabilities may be produced together because the engineering model has not yet established sufficient boundaries between them. The API, Functions, migrations, worker images, and other core runtime artifacts may initially belong to a common Institutive delivery context.

As the engineering model matures, those capabilities may acquire sufficiently independent responsibilities that they can be separated into their own repositories, artifact lifecycles, versions, and Kitting processes.

This is not the disappearance of Institutive.

The Institutive context remains the existential context of the engineering model. What changes is the degree to which individual artifacts within that context have become independently realizable.

Conceptually:

```text
early engineering model

        Institutive
             │
             └── common delivery
                  │
                  ├── API
                  ├── Functions
                  ├── migrations
                  ├── worker images
                  └── other core artifacts
```

becomes:

```text
mature engineering model

        Institutive
             │
             ├── API artifact
             │     └── independent Kitting lifecycle
             │
             ├── Functions artifacts
             │     └── independent Kitting lifecycle
             │
             ├── migration artifacts
             │     └── independent Kitting lifecycle
             │
             └── worker image artifacts
                   └── independent Kitting lifecycle
```

The engineering model has therefore not been replaced.

It has **matured its own boundaries**.

What was once a single developmental organism can differentiate into independently evolving artifacts while remaining part of the same engineering model.

### Molting

This evolutionary process can be understood as a form of **molting**.

The engineering model establishes an initial structure that is sufficient for it to develop. As the model gains capability, that structure may become constraining. The model then produces new artifacts and delivery boundaries that allow it to operate beyond the limitations of its earlier structure.

The old structure is not necessarily wrong.

It was the structure appropriate to an earlier stage of development.

The engineering model therefore does not simply replace itself. It **outgrows and replaces portions of the machinery through which it previously operated**.

The analogy is biological:

```text
          development
               │
               ▼
             pupa
               │
               │ develops internal capability
               ▼
          structural change
               │
               ▼
            molting
               │
               ▼
          new organization
               │
               ▼
           butterfly
```

The pupa and butterfly are not two unrelated organisms.

They are different realizations of the same developing organism as its structure and capabilities change.

Likewise, the Amiasea engineering model may begin with an Institutive structure in which its core artifacts are produced together. It may subsequently establish separate Kitting processes for the API, Functions, migrations, worker images, and other artifacts as those artifacts become independently versionable and independently evolvable.

The **molt is therefore an architectural transformation, not a lifecycle reset**.

The engineering model remains the subject.

Its artifacts, repositories, delivery mechanisms, and boundaries evolve around it.

### Recursive Production

The recursive relationship remains:

```text
engineering model
       │
       ▼
     Kitting
       │
       ├── API
       ├── Functions
       ├── migrations
       ├── worker images
       └── other artifacts
       │
       ▼
artifacts capable of
establishing / managing
the engineering model
```

The engineering model itself does not enter Kitting.

Kitting produces artifacts **of** the engineering model.

As those artifacts become capable of establishing and maintaining increasingly large portions of the engineering model, the distinction between the machinery used to engineer the model and the artifacts produced by that machinery becomes increasingly recursive.

This is the mechanism through which the engineering model approaches Uroboros.

### Amiasea API

The Amiasea API may be one of the most significant artifacts in this transition.

Early in the engineering model's development, the API may be simply one application produced by Institutive delivery.

As the model matures, the API may become sufficiently capable of expressing and manipulating the engineering model's own object model that it becomes an important mechanism through which other artifacts and contexts are established and governed.

At that point, the API may itself be independently versioned and independently kitted:

```text
engineering model
       │
       ▼
     Kitting
       │
       ▼
   Amiasea API
       │
       │ establishes / manages
       ▼
engineering model
```

The API is therefore not the engineering model itself.

It is an artifact of the engineering model that may eventually become capable of participating in the model's own establishment and maintenance.

The same principle can apply to Functions, migration artifacts, worker images, and other independently evolving components. Their separation into independent repositories and Kitting lifecycles does not fragment the engineering model; it can instead represent the engineering model becoming sufficiently mature to recognize and manage those components as distinct artifacts.

### The Uroboros Boundary

The Uroboros boundary is reached when the engineering model has acquired sufficient capability to establish and maintain its own required engineering artifacts through its established authority and delivery mechanisms.

At that point:

```text
external bootstrap authority

            │

            ▼

       Imperative
            │
            │
            ▼

        automation
            │
            ▼

       Institutive
            │
            ▼

   engineering model
            │
            ▼

        Kitting
            │
      ┌─────┼─────────────┐
      ▼     ▼      ▼      ▼
     API Functions migrations workers
      │     │      │       │
      └─────┴──────┴───────┘
                    │
                    ▼
       establish / maintain
          engineering model
                    │
                    └───────────────►
```

The external bootstrap authority remains prior to the system.

Uroboros does not eliminate that boundary; it identifies the point at which the engineering system no longer requires an external authority merely to perform the ordinary work of establishing and maintaining itself.

Uroboros therefore does not mean that Amiasea becomes its own ultimate jurisdictional instigator.

The system may become capable of recursively engineering itself while remaining dependent upon the authority and reality that preceded its establishment.

The engineering model may nevertheless continue to evolve after reaching this condition. Uroboros is not architectural stasis. Recursive closure includes the ability to produce the artifacts and mechanisms required for further evolution.

## Amiasea as Uroboros

Uroboros is therefore the ultimate architectural objective of Amiasea.

The individual concepts describe increasingly complete aspects of the engineering model:

* **Primitive** describes fundamental capabilities as they are established.
* **Imperative** describes established prerequisites upon which contexts depend.
* **Institutive** describes the existential context in which an engineering model is established and maintained.
* **Speculative**, **Prospective**, and **Operative** describe positions within realization and delivery.
* **Uroboros** describes the condition in which the engineering model becomes recursively capable of establishing and maintaining the engineering system of which it is itself a part.

The objective is consequently not merely to automate infrastructure provisioning.

It is to establish an engineering model capable of **engineering itself while continuing to evolve**.

The metaphor is deliberate.

The **Uroboros** represents a system whose end returns to its beginning: the artifacts produced by the engineering system ultimately become part of the machinery through which that engineering system is itself established and maintained.

The biological metaphor extends this idea further.

The engineering model may begin in a **pupal** state: coherent but structurally constrained, with multiple capabilities developed together because the model has not yet differentiated them into independent artifacts.

Through successive acts of development and **molting**, the engineering model can establish new boundaries, separate artifacts into independent repositories and lifecycles, and produce those artifacts through their own Kitting processes.

The resulting **butterfly** is not a different engineering model.

It is the same engineering model in a more mature structural realization.

For Amiasea, the eventual realization of this condition may be expressed through the Amiasea API and the other independently evolving artifacts produced by the engineering model: an ecosystem of artifacts that exposes, implements, and governs the engineering model while participating in its continued evolution.

The Amiasea API would therefore become not merely an artifact **of** the engineering model, but an artifact **through which the engineering model becomes recursively complete and capable of further transformation**.

The Imperative workstream remains outside that recursive production relationship. It establishes the prerequisites under which the engineering model can exist and operate; it does not pass through the engineering model's own Strata and Kitting lifecycle.

Institutive likewise remains the existential context of the engineering model throughout its evolution. The fact that artifacts eventually acquire independent repositories, versions, and Kitting lifecycles does not eliminate Institutive; it demonstrates that the engineering model has matured enough to produce and govern its constituent artifacts independently.

The molt is therefore not the death of the old engineering model.

It is the mechanism by which the engineering model **outgrows the structure that previously contained it**.

This is the intended end goal of Amiasea.
