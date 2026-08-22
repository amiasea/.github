# Delivery

Delivery is an aspect of the Amiasea engineering model through which engineering work is established, promoted, and operated.

Delivery establishes the infrastructure, hosting architecture, access relationships, execution mechanisms, and delivery machinery required to realize selected engineering work.

Delivery does not represent the entire engineering model.

The engineering model is the higher-order ontology within which concepts such as delivery, Institutive, Strata, and Kitting are understood.

> **The engineering model defines what is being engineered; Delivery establishes and operates mechanisms through which selected engineering work is realized.**

## Engineering Model

The engineering model defines the concepts through which engineering work, infrastructure, delivery, and operational responsibility are understood and governed.

Infrastructure constructs are realizations of those concepts rather than definitions of them.

A subscription, account, resource group, Terraform workspace, Terraform stack, repository, service, or other provider or control-plane construct may realize an engineering-model concept without becoming its semantic definition.

> **Infrastructure realizes the engineering model; infrastructure constructs do not define its ontology.**

Delivery is therefore an important aspect of the engineering model, but it is not synonymous with the engineering model itself.

## Work Streams

The engineering model contains distinct work streams.

The current delivery-oriented work streams are:

```text
Institutive
    │
    ├── establishes institutional delivery machinery
    │
    ├── Strata
    │
    └── Kitting
```

Institutive establishes the institutional machinery through which engineering work can be delivered.

Strata establishes the hosting model.

Kitting delivers applications and domain workloads into the hosting model established by Strata.

These are semantic work streams rather than infrastructure or repository boundaries.

A delivery mechanism does not become part of the work it delivers merely because it is implemented alongside that work.

An Institutive artifact may therefore exist in a bootstrap configuration, a delivery workspace, an application repository, a Strata repository, a GitHub workflow, an API, or another implementation mechanism.

Likewise, the existence of a `delivery/institutive` directory does not imply that it contains all Institutive work.

## Delivery Workspace Structure

The `delivery/` directory contains Terraform workspaces and supporting configuration used to establish selected parts of the delivery architecture.

The current structure includes:

```text
delivery/

├── _bootstrap
├── institutive
├── strata
└── kitting
```

These directories are implementation boundaries within the delivery architecture. They are not complete semantic representations of the work streams.

In particular:

* `_bootstrap` establishes foundational delivery control structures;
* `institutive` establishes selected institutional infrastructure for the delivery model;
* `strata` establishes durable infrastructure for the Strata hosting model; and
* `kitting` establishes infrastructure required by the Kitting delivery model.

Other Institutive artifacts may exist outside these directories.

For example, a GitHub workflow in the `amiasea/strata` repository may be Institutive work when its responsibility is to establish or operate delivery machinery rather than Strata hosting infrastructure.

> **A filesystem location identifies where delivery machinery is implemented; it does not determine the semantic work stream to which that machinery belongs.**

## Delivery Establishment

The initial delivery architecture is established through a sequence of dependent concerns.

The current establishment sequence is:

```text
strata
  ↓
kitting
  ↓
access
```

The ordering describes architectural establishment rather than requiring every resource to become operational immediately.

After establishment, workspaces and other delivery mechanisms may be updated independently.

Their dependencies remain connected and may require downstream reconciliation when upstream boundaries, identifiers, credentials, or infrastructure change.

`_bootstrap` participates in establishing the delivery control plane and its foundational Terraform execution structures. It is not itself a promotional stage.

> **Delivery establishes an ordered architecture and maintains it as a connected system.**

## Strata

`delivery/strata` establishes the durable infrastructure required to realize the Strata hosting model.

Strata establishes:

* promotional-stage infrastructure;
* Hosting;
* Collective;
* logical hosting domains;
* clusters;
* cloud services required by the hosting model; and
* other infrastructure required to host applications.

Strata has three promotional stages:

```text
Speculative
    ↓
Prospective
    ↓
Operative
```

The stages have distinct topologies and delivery mechanics.

The delivery workspace establishes their infrastructure but does not itself operate their runtime promotional state.

### Provider Boundaries

Provider constructs acquire their engineering meaning from the responsibility they realize.

An Azure subscription may establish the infrastructure boundary for a Strata promotional stage. An Azure resource group may realize a Strata Hosting environment within that boundary.

Neither provider construct defines the semantic concept by itself.

### Strata Environments

A Strata environment is a bounded hosting context within a Hosting scope.

The current environment boundary is the Azure resource-group level:

```text
Strata promotional stage
  ↓
provider boundary
  ↓
Hosting environment
  ↓
resource group
  ↓
logical cluster domain
```

A subscription contains environments but is not itself an environment.

An environment may contain one or more logical cluster domains. Those domains belong to Strata's hosting jurisdiction and are independent of Kubernetes scaling mechanics.

## Promotional Stages

### Speculative

Speculative provides contexts in which candidate Strata changes can be realized and evaluated.

`delivery/strata` establishes the durable infrastructure and the capacity contract for Speculative.

The runtime operation of that capacity is performed through delivery machinery, including the Amiasea API and the Speculative Capacity Manager role.

The detailed promotional semantics are defined in:

`strata/promotion/speculative.md`

### Prospective

Prospective validates an approved Strata realization before promotion into Operative.

Its topology, validation contexts, and correlation mechanics are specific to Prospective and are not inherited from Speculative.

The detailed promotional semantics are defined in:

`strata/promotion/prospective.md`

### Operative

Operative establishes the accepted operating realization of Strata.

Its internal mechanics for live and new realizations, replication, traffic control, and other operating concerns are stage-specific.

Operative has not yet been fully defined by the delivery model.

## Hosting and Collective

Each Strata promotional stage contains two primary scopes:

```text
Promotional Stage

├── Hosting
└── Collective
```

Hosting establishes bounded hosting environments.

Collective establishes capabilities whose responsibility extends across Hosting environments or which have their own meaningful segmentation model.

Collective is not a fourth promotional stage.

```text
Speculative
├── Hosting
└── Collective

Prospective
├── Hosting
└── Collective

Operative
├── Hosting
└── Collective
```

Hosting and Collective may have separate repositories when their lifecycles and validation responsibilities warrant that separation.

For Speculative, the current repositories are:

```text
strata-hosting
strata-collective
```

Their separate repositories do not create separate promotional stages. They represent distinct delivery lifecycles within the same Strata stage.

## Speculative Capacity

The durable Strata delivery architecture establishes the capacity boundary within the `amiasea-speculative` provider boundary.

Within that boundary, **Speculative Capacity Manager** is a delivery role responsible for operating speculative environment capacity.

The role does not imply a separate service.

The capacity contract may define the minimum and maximum number of environments that may exist for each environment type:

```text
Speculative Capacity

├── Hosting
│   └── min / max environments
│
└── Collective
    └── min / max environments
```

The initial implementation may use static values.

The contract intentionally does not expose the mechanics by which capacity is maintained.

The Speculative Capacity Manager may:

* observe capacity;
* respond to candidate demand;
* reserve environments;
* identify available environments;
* provision additional capacity within the contract;
* reconcile capacity proactively; and
* release capacity when appropriate.

A candidate request is therefore an input to capacity management, not its exclusive trigger.

A consumer requests an environment rather than requesting creation of a resource group.

```text
candidate demand
      ↓
Speculative Capacity Manager
      ↓
environment available
```

The consumer does not need to know whether the environment was already available, provisioned in response to demand, or made available through another capacity mechanism.

> **Delivery establishes the capacity contract; the Speculative Capacity Manager operates that capacity.**

## Strata and Kitting

Kitting has its own promotional lifecycle:

```text
Strata

├── Speculative
├── Prospective
└── Operative

Kitting

├── Speculative
├── Prospective
└── Operative
```

These stages are independent.

Kitting does not pass through Strata promotion, and Strata promotion does not advance Kitting.

Kitting consumes Strata hosting capabilities while maintaining its own delivery state.

The shared terminology of Speculative, Prospective, and Operative therefore does not imply synchronization between the two work streams.

## Kitting as a Strata Workload

Strata may use an accepted Kitting release as a representative workload when validating its hosting model.

```text
Kitting
    ↓
accepted release
    ↓
Strata validation
```

This is a consumption and compatibility relationship, not a promotion relationship.

A Kitting release used by Strata remains part of Kitting's delivery lifecycle.

> **Strata promotes its hosting model independently while using accepted workloads to prove compatibility.**

## Access

`delivery/access` establishes relationships through which expected execution subjects may act within the delivery architecture.

These relationships may involve:

* principals;
* trust;
* accreditation;
* delegation;
* permissions; and
* authority.

OIDC is one access mechanism used by the delivery architecture.

Provider constructs such as managed identities are realizations of principal concepts rather than definitions of those concepts.

Conceptually:

```text
delivery infrastructure
  ↓
provider boundaries
  ↓
access relationships
  ↓
principals and trust
  ↓
permissions
```

Access establishes relationships between the delivery architecture and its expected execution subjects. It does not itself define the semantic identity of those subjects.

## Amiasea API

The Amiasea API is Institutive work and is part of the delivery machinery established by the engineering model.

Its initial operational capability is orchestration of Strata promotion.

The API does not establish Strata infrastructure.

```text
Terraform
    ↓
durable Strata architecture
    ↓
Amiasea API
    ↓
orchestration
    ↓
GitHub workflows
    ↓
Terraform / HCP Terraform execution
```

The API may maintain delivery state such as:

* candidate lifecycle;
* promotion eligibility;
* environment reservation;
* capacity coordination;
* environment assignment;
* workflow dispatch; and
* observed execution results.

This state is delivery state rather than Strata infrastructure state.

The API may perform the Speculative Capacity Manager role without requiring that role to become a separate service.

Detailed orchestration mechanics are documented separately in:

`strata/promotion/orchestration.md`

## GitHub Workflows

GitHub workflows are execution mechanisms within the delivery architecture.

They may execute Terraform, interact with HCP Terraform through the Terraform CLI, or perform other bounded delivery operations.

A workflow does not become a Strata resource because it executes Strata Terraform.

Conversely, a workflow may constitute Institutive work when its purpose is to establish or operate delivery machinery.

For example, a workflow in the `amiasea/strata` repository that creates or manages a Terraform workspace may be an Institutive artifact even though it is physically located within a Strata repository.

The workflow surface is therefore defined by the responsibility of each workflow rather than solely by its repository location.

```text
Amiasea API
    ↓
orchestration decision
    ↓
GitHub workflow
    ↓
execution
```

The workflow performs execution and exposes its result through GitHub. Orchestration state remains with the appropriate delivery machinery.

## HCP Terraform

HCP Terraform provides workspace-based Terraform execution within the delivery architecture.

A VCS-connected workspace may follow a feature branch and automatically produce speculative Terraform evaluations.

```text
feature branch
    ↓
VCS-connected workspace
    ↓
HCP Terraform run
    ↓
speculative report
```

The workspace and its Terraform state are execution artifacts.

They do not define the semantic identity of the candidate or promotional stage.

HCP Terraform is itself part of the broader engineering delivery machinery rather than being synonymous with any particular work stream.

## Sovereign Variable Set

The sovereign variable set provides authoritative context to applicable Terraform execution workspaces.

The variable set is not itself the authority.

`_bootstrap` establishes its instantiation and jurisdiction. Authoritative infrastructure may subsequently populate it with values required by the delivery architecture.

This separates:

* authoritative context;
* the mechanism carrying that context; and
* the organization of Terraform execution artifacts.

## Delivery and Jurisdiction

Jurisdiction defines semantic boundaries of engineering responsibility.

Delivery establishes the infrastructure and machinery through which those responsibilities are realized.

```text
Jurisdiction
    ↓
engineering responsibility
    ↓
Delivery
    ↓
infrastructure and machinery
```

The jurisdiction concepts are defined separately in `jurisdiction.md`.

Delivery may establish infrastructure for those concepts without redefining them.

## Delivery Lifecycle

During initial establishment:

```text
strata
  ↓
kitting
  ↓
access
```

Strata establishes the hosting architecture.

Kitting establishes infrastructure required by the Kitting delivery model.

Access establishes the relationships through which the delivery architecture may be operated.

Later changes may affect individual workspaces without requiring the entire sequence to run again.

The architecture remains connected even when its individual workspaces evolve independently.

> **Ordered during establishment, connected during maintenance.**

## Institutive

Institutive is the work stream concerned with the **institutional aspects of establishing and operating the delivery model**.

Institutive is not synonymous with the `delivery/institutive` directory.

The `delivery/institutive` directory contains selected Institutive infrastructure, including infrastructure for the Amiasea application surface and associated institutional capabilities such as the sovereign Key Vault.

Other Institutive artifacts may be realized elsewhere.

Examples include:

* `_bootstrap` configuration that establishes the delivery control plane;
* GitHub workflows that establish or operate delivery mechanisms;
* HCP Terraform configuration that establishes delivery execution;
* the Amiasea API and UI;
* webhook integration;
* identity and trust configuration;
* promotion orchestration; and
* other machinery required to establish and operate the delivery model.

An artifact belongs to Institutive according to the engineering responsibility it realizes, not according to the repository or directory in which it is stored.

Infrastructure in the `amiasea-institutive` subscription is therefore not part of Strata merely because Strata depends upon capabilities or authority established by Institutive.

Similarly, an Institutive workflow may exist within the Strata repository without becoming Strata work.

The Amiasea API, capacity-management role, GitHub workflows, Terraform delivery workspaces, and related control-plane mechanisms are delivery machinery even when they operate on behalf of Strata.

> **Institutive is a semantic work stream; `delivery/institutive` is only one implementation location for that work.**

## Delivery as an Aspect of the Engineering Model

Delivery should not be interpreted as the complete Amiasea engineering model.

The engineering model is the higher-order ontology.

Delivery is the aspect concerned with establishing, promoting, operating, and connecting engineering work through infrastructure and delivery machinery.

This distinction permits the engineering model to describe concepts that are broader than any particular delivery implementation.

```text
Amiasea Engineering Model
        │
        └── Delivery
             │
             ├── Institutive
             ├── Strata
             └── Kitting
```

The work streams remain semantic even when their implementations cross repository, workspace, subscription, provider, or service boundaries.

## Boundary Principle

Delivery contains mechanisms necessary to establish and operate:

* hosting architecture;
* delivery architecture;
* access relationships;
* execution subjects;
* control-plane integration;
* capacity contracts; and
* dependencies required by the delivery system.

A concept belongs in engineering-model documentation when it describes what is being engineered.

A workspace, workflow, API role, or Terraform construct belongs in Delivery when it provides a mechanism for instantiating, operating, or connecting that architecture.

The repository structure, Terraform workspace structure, HCP Terraform organization, API structure, and provider boundaries do not need identical semantic boundaries.

The `delivery/` directory therefore represents an implementation surface, not the ontology of Delivery itself.

> **The engineering model defines what exists. Delivery establishes and operates the infrastructure and machinery required to realize selected engineering work.**
