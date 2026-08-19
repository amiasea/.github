# Amiasea API

The Amiasea API is a platform primitive established by Institutive.

It provides the common control-plane boundary through which Amiasea receives events, maintains platform state, coordinates platform activity, and exposes capabilities to automation and future Amiasea user interfaces.

The API is not itself a Strata component. Strata promotion is one capability currently implemented through the API.

Other capabilities may exist independently of Strata, including future capabilities such as SSO.

> **The Amiasea API is the common platform boundary; its capabilities provide distinct responsibilities within that boundary.**

# Platform Boundary

The API connects external event sources, platform capabilities, execution mechanisms, and user interfaces.

```text
GitHub ──────────────┐
                     │
HCP Terraform ───────┤
                     ▼
                Amiasea API
                 │    │
                 │    └── Amiasea UI
                 │
                 └── platform capabilities
                         │
                         ▼
                  external systems
```

The API does not replace the systems with which it integrates.

GitHub remains responsible for source control, repository governance, workflow execution, and GitHub-originated events.

HCP Terraform remains responsible for Terraform workspace execution, configuration versions, runs, and state.

The API provides the common platform boundary through which Amiasea coordinates those systems.

# Platform Capabilities

A platform capability is a distinct responsibility provided through the Amiasea API.

Capabilities are independent at the semantic level even when they share implementation infrastructure.

The initial capability is:

```text
Amiasea API
└── Strata Promotion
```

The platform may subsequently contain capabilities such as:

```text
Amiasea API
├── Strata Promotion
├── SSO
├── ...
└── ...
```

The existence of one capability does not establish a hierarchy over the others.

Each capability may have its own domain concepts, state, events, authorization requirements, and external integrations.

# Strata Promotion Capability

Strata Promotion is the initial operational capability of the Amiasea API.

It provides the orchestration machinery required to coordinate Strata promotional activity.

```text
Amiasea API
└── Strata Promotion
    ├── orchestration
    ├── capacity
    ├── assignment
    └── execution dispatch
```

The API does not define the Strata ontology.

Strata defines the semantic hosting domain and its promotional lifecycle. The API provides machinery through which that lifecycle is coordinated.

The Strata promotion roles are documented in:

`strata/promotion/orchestration/roles.md`

# Speculative Capacity Manager

The Speculative Capacity Manager is a responsibility within Strata Promotion.

It coordinates the allocation of paired Speculative capacity to pull requests.

Speculative capacity is established independently by the delivery infrastructure. Each capacity slot consists of a Hosting environment and a Collective environment of the same size.

```text
amiasea-speculative
├── Speculative slot 01
│   ├── Hosting environment
│   └── Collective environment
├── Speculative slot 02
│   ├── Hosting environment
│   └── Collective environment
└── ...
```

The paired environments may be identified by a shared slot number and corresponding resource-group tags.

Conceptually:

```text
Speculative slot
    │
    ├── Hosting
    └── Collective
```

A pull request is assigned a single available slot. The assignment therefore establishes both environment identities for the speculative realization.

```text
pull request
    │
    ▼
Speculative Capacity Manager
    │
    └── slot 03
         ├── hosting_environment_id
         └── collective_environment_id
```

The SCM does not need to understand the Terraform configuration, Azure resource-group implementation, or provider-specific machinery used to establish that capacity.

Those mechanisms are platform infrastructure.

The SCM provides the orchestration boundary over them.

The capacity model is documented in:

`strata/promotion/orchestration/capacity.md`

# Event-Driven Operation

The API is event-driven and does not poll participating systems.

GitHub delivers repository, pull request, review, and workflow events through webhooks.

HCP Terraform may deliver workspace and Terraform execution events through its notification mechanisms.

Platform infrastructure and other delivery machinery may provide additional observations required by a capability.

```text
GitHub ───────────────┐
                      │
HCP Terraform ────────┤
                      │
platform machinery ───┤
                      ▼
                 Amiasea API
```

The API interprets external events and may derive logical events used by a platform capability.

The API does not periodically query systems to discover whether something happened.

> **The API reacts to observations emitted by participating systems rather than discovering state through polling.**

The event model for Strata promotion is documented in:

`strata/promotion/orchestration/events.md`

# Platform State

The API may maintain state required by its platform capabilities.

For Strata Promotion, this may include:

* pull requests;
* revisions;
* eligibility;
* capacity assignments;
* speculative workspace identities;
* configuration-version identities;
* observed execution state; and
* promotional state.

This state is coordination state, not infrastructure state.

```text
Terraform state
    → infrastructure realization

HCP Terraform
    → workspace, configuration-version, run, and execution state

API state
    → platform coordination
```

The API does not become a second Terraform state system.

The API may reference infrastructure identities and execution resources without becoming their system of record.

Other platform capabilities may maintain entirely different forms of state.

# Strata Promotion Roles

Roles are responsibilities performed within a capability.

They are not necessarily separate services or deployments.

Within Strata Promotion, the initial role is the **Speculative Capacity Manager**.

```text
Amiasea API
└── Strata Promotion
    └── Speculative Capacity Manager
```

The SCM is responsible for the orchestration of Speculative capacity and promotional activity.

Its responsibility may include:

* receiving repository and pull-request events;
* determining whether a pull request is eligible for Speculative realization;
* observing available capacity;
* assigning a paired Speculative slot;
* maintaining coordination state;
* dispatching bounded delivery operations;
* advancing the speculative workspace lifecycle; and
* interpreting resulting events.

The SCM does not necessarily own the infrastructure, workflows, Terraform configuration, or provider resources through which those operations are performed.

This distinction allows the API to govern the platform without coupling the role to implementation details.

The distinction is important:

```text
Platform capability
    ↓
responsibility
    ↓
role
    ↓
platform primitives
```

The platform primitives are the mechanisms through which the role acts.

A role does not become a new platform capability merely because the implementation gives it a distinct module or component.

# Speculative Realization

Speculative realization is the first promotional execution of a Strata pull request.

The speculative workspace is not VCS-connected.

The API reacts to the pull request and coordinates creation or reuse of a dedicated HCP Terraform workspace representing the pull request's speculative lifecycle.

The workspace receives Terraform configuration assembled from:

```text
Strata pull-request revision
        +
Strata speculative delivery template
        +
assigned environment values
```

The speculative delivery template is maintained in:

`amiasea/.github/terraform/delivery/strata/speculative`

The delivery workflow checks out the required repository revisions, assembles the Terraform configuration, creates the configuration archive, and uploads it to the HCP Terraform workspace as a configuration version.

The speculative workspace therefore does not need to observe GitHub directly.

```text
Pull request
    │
    ▼
Amiasea API
    │
    ├── assign Speculative slot
    ├── identify revision
    └── dispatch delivery workflow
              │
              ├── checkout Strata revision
              ├── checkout delivery template
              ├── assemble configuration
              └── upload configuration version
                         │
                         ▼
                  HCP Terraform workspace
                         │
                         ▼
                  speculative run
```

The workspace persists for the lifecycle of the pull request.

When the pull request receives a new commit, the API repeats the configuration-version process against the new revision rather than creating a new workspace.

This preserves the workspace and run history across revisions.

The speculative workspace represents the paired graph:

```text
Speculative workspace
├── Hosting
└── Collective
```

Both receive the environment assignments established by the same Speculative slot.

HCP Terraform's VCS-driven pull-request speculative-run mechanism is therefore not part of this flow. The API and delivery workflow explicitly construct and execute the speculative realization.

# Execution

The API coordinates execution but does not directly execute Terraform.

When a platform capability requires execution, the API may dispatch an appropriate workflow or invoke another bounded execution mechanism.

For Strata promotion:

```text
event
  ↓
Amiasea API
  ↓
Strata promotion decision
  ↓
GitHub delivery workflow
  ↓
HCP Terraform
  ↓
Terraform
```

The delivery workflow is an execution mechanism used by the Strata Promotion capability.

The workflow does not become the authority for the decision that caused it to execute.

For Speculative realization, the workflow is responsible for mechanical delivery operations such as:

* checking out the requested Strata revision;
* checking out the applicable delivery template;
* composing the Terraform configuration;
* creating a configuration archive;
* creating or updating the HCP Terraform configuration version; and
* initiating the required HCP Terraform run.

The workflow does not decide whether a pull request is eligible, which capacity slot it receives, or what promotional stage applies.

Workflow responsibilities are documented in:

`strata/promotion/orchestration/workflows.md`

# Delivery Boundary

Delivery machinery is maintained independently from the repositories containing the Strata implementation.

Strata repositories contain the Terraform implementations being delivered.

Amiasea delivery infrastructure contains the templates and workflows used to realize those implementations.

```text
Strata repository
└── terraform/
    ├── hosting/
    └── collective/

amiasea/.github
└── terraform/
    └── delivery/
        └── strata/
            ├── speculative/
            └── prospective/
```

The speculative template provides the root Terraform configuration required to compose the Hosting and Collective implementations for Speculative execution.

The delivery workflow composes that template with the requested Strata revision rather than requiring the Strata repository to contain Amiasea-specific delivery machinery.

# Prospective Promotion

After a Strata change is promoted beyond Speculative, Hosting and Collective become independently versioned artifacts.

The modules may therefore evolve independently even though they are validated together during Speculative realization.

```text
Speculative
────────────────────
one pull request
        │
        ├── Hosting
        └── Collective
        │
        ▼
paired speculative graph


Prospective
────────────────────
Hosting@version
        +
Collective@version
        │
        ▼
prospective Stack
```

The prospective delivery definition is maintained in:

`amiasea/.github/terraform/delivery/strata/prospective`

The prospective configuration publishes or references the individual PMR modules independently and composes them into the prospective Stack.

A change to one module does not require a new version of the other module when no change occurred.

The Stack therefore explicitly determines which Hosting and Collective versions form the prospective realization.

# Capacity and Execution

The SCM should consume platform capacity through stable semantic interfaces rather than directly manipulating provider-specific resources.

For example, the SCM should reason about:

```text
Speculative slot available
Speculative slot assigned
Hosting environment assigned
Collective environment assigned
environment released
```

rather than:

```text
Azure resource group exists
Terraform resource created
Terraform apply completed
resource ID discovered
```

The latter are implementation details of the platform machinery.

This separation allows the underlying capacity implementation to evolve without requiring the orchestration model to change.

The API governs the relationship between pull requests and capacity while platform infrastructure establishes the mechanisms through which capacity exists.

# User Interface

The Amiasea API is the backend interface for the eventual Amiasea UI.

The UI is a consumer of the API rather than an independent control plane.

```text
Amiasea UI
    │
    ▼
Amiasea API
    │
    ├── platform state
    └── platform capabilities
```

The UI does not directly coordinate GitHub, HCP Terraform, Terraform, or other infrastructure systems.

User-initiated actions are expressed through the API and evaluated through the same capability boundaries and authorization mechanisms used by automated activity.

The eventual UI may expose multiple platform capabilities without changing the API's common platform boundary.

# Strata Relationship

The API participates in Strata promotion but is not part of the Strata ontology.

```text
Strata
├── Speculative
├── Prospective
└── Operative

Amiasea API
└── Strata Promotion
    └── Speculative Capacity Manager
```

Strata defines:

* Hosting;
* Collective;
* environments;
* logical cluster domains;
* resources;
* capabilities; and
* promotional stages.

The API provides machinery for coordinating activity within those semantics.

It does not redefine them.

# Future Capabilities

The API is intentionally broader than its initial Strata capability.

Future capabilities may include:

* SSO;
* authentication and session management;
* authorization;
* additional delivery capabilities; and
* other Amiasea platform capabilities.

These capabilities may have independent semantics and integrations while sharing the same API boundary.

The API architecture should therefore avoid making Strata-specific concepts foundational to the platform as a whole.

# Boundary

The Amiasea API provides:

* event ingress;
* platform state;
* capability interfaces;
* coordination decisions;
* responsibility implementation; and
* action dispatch.

For Strata Promotion, this includes orchestration of Speculative capacity, pull-request activity, workspace lifecycle, and promotional execution through the Speculative Capacity Manager.

The API does not necessarily own every mechanism used by that responsibility.

The API does not own:

* GitHub repository state;
* GitHub workflow execution;
* HCP Terraform execution;
* Terraform state;
* provider infrastructure;
* Strata infrastructure as a semantic domain;
* application workloads; or
* the semantic definition of the domains it coordinates.

> **The Amiasea API is the common control-plane primitive through which Amiasea capabilities operate; its roles govern platform activity through platform primitives without becoming coupled to their implementation details.**
