# Delivery

Delivery is the workspace chain through which the infrastructure, hosting architecture, access relationships, and delivery machinery required by the engineering model are established.

Delivery does not represent the entire engineering model. It establishes the infrastructure and mechanisms through which selected engineering work can be developed, promoted, and operated.

## Engineering Model

The engineering model defines the concepts through which infrastructure is understood, established, and governed.

Infrastructure constructs are realizations of those concepts rather than definitions of them.

A subscription, account, resource group, Terraform workspace, Terraform stack, repository, service, or other provider or control-plane construct may realize an engineering-model concept without becoming its semantic definition.

> **Infrastructure realizes the engineering model; infrastructure constructs do not define its ontology.**

## Work Streams

The engineering model contains distinct work streams:

```text
Institutive
    │
    ├── delivery machinery
    ├── Strata
    └── Kitting
```

Institutive establishes the machinery through which engineering work can be delivered.

Strata establishes the hosting model.

Kitting delivers applications and domain workloads into that hosting model.

A delivery mechanism does not become part of the work it delivers merely because it is implemented alongside that work.

## Delivery Workspace Chain

The `delivery/` directory contains Terraform workspaces establishing the delivery architecture:

```text
delivery/
├── strata
├── kitting
└── access
```

These are distinct architectural concerns participating in an ordered establishment ceremony:

```text
strata
  ↓
kitting
  ↓
access
```

The ordering describes architectural establishment rather than requiring every resource to become operational immediately.

After establishment, workspaces may be updated independently. Their dependencies remain connected and may require downstream reconciliation when upstream boundaries, identifiers, credentials, or infrastructure change.

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

The delivery workspace establishes their infrastructure but does not itself operate their runtime promotion state.

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

## Amiasea API

The Amiasea API is delivery machinery established by Institutive.

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

The workflow surface is defined by the lifecycle of each Strata repository and stage rather than by a single universal workflow set.

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

Institutive establishes the delivery model and its machinery.

Infrastructure in the `amiasea-institutive` subscription, such as the sovereign key vault, is not part of Strata merely because Strata depends upon capabilities or authority established by Institutive.

The API, capacity-management role, GitHub workflows, Terraform delivery workspaces, and related control-plane mechanisms are therefore delivery machinery even when they operate on behalf of Strata.

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

> **The engineering model defines what exists. Delivery establishes and operates the infrastructure and machinery required to realize it.**
