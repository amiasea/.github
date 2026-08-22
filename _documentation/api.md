# Amiasea API

The Amiasea API is a platform primitive established by Institutive.

It provides the common control-plane boundary through which Amiasea receives events, coordinates platform activity, maintains platform coordination state, and exposes capabilities to automation and future Amiasea user interfaces.

The API is not itself a Strata component. Strata Promotion is the initial capability implemented through the API.

> **The Amiasea API is the common platform boundary; its capabilities provide distinct responsibilities within that boundary.**

# Platform Boundary

The API connects external systems, platform capabilities, execution mechanisms, and user interfaces.

```text
GitHub ───────────────┐
                      │
HCP Terraform ────────┤
                      ▼
                Amiasea API
                 │       │
                 │       └── Amiasea UI
                 │
                 └── platform capabilities
```

The API does not replace the systems with which it integrates.

GitHub remains responsible for source control, repository governance, workflow execution, and GitHub-originated events.

HCP Terraform remains responsible for Terraform workspaces, configuration versions, runs, and state.

Azure remains responsible for infrastructure resources.

The API provides the boundary through which Amiasea coordinates these systems.

The integrations form a **mesh**, rather than a one-way pipeline. Systems may both emit events to the API and receive commands from it where required.

# Platform Capabilities

A platform capability is a distinct responsibility provided through the Amiasea API.

The initial capability is:

```text
Amiasea API

└── Strata Promotion
```

Future capabilities may exist independently, including capabilities such as SSO.

Each capability may have its own domain concepts, state, events, authorization requirements, and external integrations.

# Strata Promotion

Strata Promotion provides the orchestration machinery required to coordinate Strata promotional activity.

Its initial responsibility is the **Speculative Capacity Manager**.

```text
Amiasea API

└── Strata Promotion

    └── Speculative Capacity Manager
```

The API does not define the Strata ontology.

Strata defines Hosting, Collective, environments, resources, and promotional stages. The API provides machinery through which those semantics are coordinated.

The Strata promotion model is documented in:

`strata/promotion/orchestration/`

# Speculative Capacity

Speculative capacity is established independently by the delivery infrastructure.

Capacity consists of paired Hosting and Collective environments that exist as a reusable pool.

```text
Speculative slot

├── Hosting environment
└── Collective environment
```

A pull request is assigned a single available slot.

The API governs the relationship between the pull request and the assigned capacity. It does not own the infrastructure that establishes the capacity.

The Speculative Capacity Manager reasons about semantic capacity such as:

```text
slot available
slot assigned
environment occupied
environment released
```

rather than provider-specific implementation details.

# Speculative Environment Reservation

Speculative environments are pooled capacity. They exist independently of pull requests and may be reused after a candidate releases them.

The Speculative Capacity Manager considers an environment **reserved** when an active speculative workspace has successfully realized against that environment.

The relationship is:

```text
Speculative workspace
        │
        │ successful realization
        ▼
Speculative environment
        │
        └── reserved by workspace
```

The workspace is the logical identity of the reservation.

The API does not maintain a separate allocation record solely to represent this relationship. Instead, the reservation is represented through existing platform identities and lifecycle events.

The physical implementation of a Speculative environment may carry metadata identifying the workspace that currently occupies it:

```text
amiasea:workspace-id = <workspace-id>
```

This metadata is a projection of the reservation. It is not the system of record for the reservation.

When the API observes successful realization of a speculative workspace, it establishes the corresponding environment association.

When the API observes destruction or release of that workspace, it removes the association.

```text
successful realization
        │
        ▼
environment reserved
        │
        │
workspace destroyed
        │
        ▼
environment released
```

An environment that has no active workspace association is available for assignment.

The Speculative Capacity Manager therefore reasons in terms of:

```text
available environment
reserved environment
released environment
```

rather than the provider-specific resources used to implement those environments.

The underlying infrastructure establishes the pool of environments. The API governs the relationship between speculative candidates and that capacity.

# Event-Driven Operation

The API is event-driven and does not poll participating systems to discover activity.

GitHub delivers repository, pull request, review, and workflow events through webhooks.

HCP Terraform delivers workspace and execution observations through its notification mechanisms.

```text
GitHub ───────────────┐
                      │
HCP Terraform ────────┤
                      ▼
                Amiasea API
```

The API interprets external events and may issue bounded commands in response.

A query against an integrated system is permitted when required to complete a specific operation, but polling is not the mechanism by which the API discovers state.

> **The API reacts to observations emitted by participating systems rather than periodically discovering activity through polling.**

# Platform State

The API may maintain coordination state required by its capabilities.

For Strata Promotion this may include:

* pull requests;
* revisions;
* eligibility;
* capacity assignments;
* speculative workspace identities; and
* promotional state.

This is **coordination state**, not infrastructure state.

```text
Terraform state
    → infrastructure realization

HCP Terraform
    → workspace and execution state

Amiasea API
    → platform coordination
```

The API should prefer existing authoritative systems and their events over creating custom persistence for relationships already represented elsewhere.

The API does not become a second Terraform state system.

# Speculative Realization

A speculative workspace represents the Terraform execution context for a pull request.

The workspace is dynamically created and identified by the pull request:

```text
speculative-pr-<pull-request-number>
```

The API determines eligibility, assigns capacity, identifies the requested revision, and dispatches the appropriate delivery workflow.

The delivery workflow performs bounded mechanical operations such as creating and configuring the HCP Terraform workspace.

```text
Pull request
    │
    ▼
Amiasea API
    │
    ├── determine eligibility
    ├── assign Speculative slot
    ├── identify revision
    └── dispatch workflow
             │
             ├── create workspace
             ├── configure VCS
             └── configure variables
```

The workflow does not decide whether the pull request is eligible or which capacity it receives.

The API coordinates the lifecycle through the resulting events.

The workspace receives the environment assignments associated with its Speculative slot. These assignments are workspace-specific configuration rather than reusable project-wide configuration.

# Speculative Workspace Lifecycle

The API coordinates the speculative workspace lifecycle through events and bounded commands.

```text
PR created
    │
    ▼
eligibility determined
    │
    ▼
Speculative slot assigned
    │
    ▼
workspace created
    │
    ▼
Terraform execution
    │
    ▼
successful realization
    │
    ▼
environment reserved
    │
    ▼
candidate remains active
    │
    ▼
workspace destroyed
    │
    ▼
environment released
```

The successful Terraform execution event establishes that the candidate has successfully realized against its assigned Speculative environment.

The API may use this observation to establish the corresponding environment association.

Workspace destruction or release produces the corresponding observation that allows the API to release the environment.

# Execution Boundary

The API coordinates execution but does not directly execute Terraform.

For Strata Promotion:

```text
event
  ↓
Amiasea API
  ↓
promotion decision
  ↓
GitHub workflow
  ↓
HCP Terraform
  ↓
Terraform
```

The workflow is an execution mechanism, not the authority for the decision that caused it to run.

The API remains responsible for interpreting resulting events and advancing the capability lifecycle.

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

The delivery machinery is an implementation primitive of the Strata Promotion capability.

It is not itself the authority for promotional decisions.

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

The Stack explicitly determines which Hosting and Collective versions form the prospective realization.

# User Interface

The Amiasea API is the backend boundary for the eventual Amiasea UI.

```text
Amiasea UI
    │
    ▼
Amiasea API
    │
    └── platform capabilities
```

The UI does not directly coordinate GitHub, HCP Terraform, Azure, or other infrastructure systems.

User-initiated actions are expressed through the API and evaluated through the same capability boundaries and authorization mechanisms used by automated activity.

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
* resources; and
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
* platform coordination state;
* capability interfaces;
* coordination decisions; and
* bounded action dispatch.

The API does not own:

* GitHub repository state;
* GitHub workflow execution;
* HCP Terraform execution;
* Terraform state;
* Azure infrastructure;
* Strata's semantic ontology; or
* application workloads.

The API should not become a polling-based synchronization layer or a second state system for its integrated platforms.

> **The Amiasea API is the common control-plane primitive through which Amiasea capabilities coordinate platform activity without becoming the system of record for the systems they integrate with.**
