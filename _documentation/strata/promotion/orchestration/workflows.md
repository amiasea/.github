# Promotion Workflows

Promotion workflows are execution mechanisms used by the Strata delivery architecture.

They translate an orchestration decision into a bounded execution operation. They do not define promotional semantics, own promotional state, or continuously monitor external systems.

> **A workflow executes a delivery operation; it does not decide what the delivery operation means.**

# Workflow Boundary

The execution boundary is:

```text
Amiasea API
    ↓
GitHub workflow dispatch
    ↓
GitHub Actions
    ↓
Terraform / HCP Terraform
```

The resulting execution state is observed through events:

```text
GitHub
    ↓
workflow events
    ↓
Amiasea API

HCP Terraform
    ↓
workspace notification
    ↓
Amiasea API
```

Neither the API nor the workflow polls for execution state.

GitHub and HCP Terraform provide the event surfaces through which execution becomes observable.

# Workflow Role

A workflow performs a bounded execution operation.

Its responsibilities may include:

* accepting execution inputs;
* establishing execution context;
* authenticating to required systems;
* invoking Terraform or another execution mechanism;
* waiting for the requested operation to complete; and
* exposing resulting execution state through the provider's event mechanisms.

A workflow does not own:

* promotion policy;
* eligibility;
* capacity allocation;
* environment reservation;
* queue policy;
* component correlation;
* long-lived promotional state; or
* Strata resource semantics.

Those responsibilities belong to the appropriate orchestration or domain roles.

# Workflow Dispatch

The Amiasea API may dispatch a workflow when an orchestration decision requires execution.

```text
event
  ↓
Amiasea API
  ↓
orchestration decision
  ↓
GitHub workflow dispatch
  ↓
GitHub Actions
```

The workflow receives the execution context required for the operation.

For example:

```text
pull request
revision
environment assignment
workspace identity
operation
```

The workflow should not reconstruct the decision that caused it to be dispatched.

# Execution and Observation

Execution and observation are separate concerns.

```text
Amiasea API
    ↓
workflow dispatch
    ↓
GitHub Actions
    ↓
execution
```

Execution results subsequently become events:

```text
GitHub Actions
    ↓
GitHub workflow event
    ↓
Amiasea API
```

For Terraform operations executed through an HCP Terraform workspace:

```text
GitHub Actions
    ↓
Terraform / HCP Terraform API
    ↓
HCP Terraform workspace
    ↓
Terraform execution
    ↓
HCP Terraform notification
    ↓
Amiasea API
```

The API therefore reacts to execution results rather than polling for them.

> **The delivery loop is event-driven: dispatch creates execution, and execution systems emit the observations that drive the next decision.**

# Terraform Execution

Strata workflows may use Terraform CLI or HCP Terraform APIs to initiate Terraform operations.

```text
workflow
    ↓
Terraform / HCP Terraform API
    ↓
HCP Terraform
    ↓
remote execution
```

HCP Terraform remains responsible for Terraform execution and workspace state.

The workflow does not reproduce Terraform's state model or become a second Terraform orchestration system.

# Speculative Workspaces

Speculative workspaces are execution identities for the lifecycle of a pull request.

They are not VCS-connected.

The Amiasea API reacts to pull-request events and coordinates the creation or reuse of an HCP Terraform workspace for that pull request.

The workspace receives configuration versions assembled from:

```text
Strata pull-request revision
        +
Strata speculative delivery template
        +
assigned environment values
```

The speculative delivery template is maintained in:

`amiasea/.github/terraform/delivery/strata/speculative`

The delivery workflow checks out the required Strata revision and delivery template, assembles the Terraform configuration, creates the configuration archive, and uploads it to the HCP Terraform workspace.

```text
Pull request
    ↓
Amiasea API
    ↓
workspace lifecycle decision
    ↓
GitHub workflow dispatch
    ↓
checkout Strata revision
    +
checkout delivery template
    ↓
assemble configuration
    ↓
configuration version
    ↓
HCP Terraform workspace
    ↓
speculative run
```

The speculative workspace represents the paired Hosting and Collective graph:

```text
Speculative workspace
├── Hosting
└── Collective
```

The two environments are assigned together as one Speculative capacity slot.

When the pull request receives a new commit, the workflow uploads a new configuration version to the same workspace. The workspace and its run history therefore persist across revisions.

HCP Terraform's VCS-driven pull-request speculative-run mechanism is not part of this flow.

# Speculative Workflow

The Speculative workflow performs the bounded delivery operation required to realize a pull request in its assigned Speculative workspace.

Its responsibilities may include:

* checking out the requested Strata revision;
* checking out the Speculative delivery template;
* composing the root Terraform configuration;
* supplying assigned environment values;
* creating the configuration archive;
* uploading the configuration version;
* initiating the speculative run; and
* reporting execution results through GitHub and HCP Terraform events.

The workflow does not decide:

* whether the pull request is eligible;
* which Speculative capacity slot is assigned;
* which environments belong to that slot; or
* whether the resulting execution satisfies promotional requirements.

Those are orchestration concerns.

# Prospective Workflows

Prospective workflows support the lifecycle defined by `stages/prospective.md`.

Prospective delivery consumes independently versioned Hosting and Collective artifacts.

The prospective delivery definition is maintained in:

`amiasea/.github/terraform/delivery/strata/prospective`

The prospective configuration may publish and compose the individual PMR modules independently.

```text
Hosting@version ─────┐
                     ├── prospective Stack
Collective@version ──┘
```

A change to one module does not require a new version of the other module when no change occurred.

The workflow does not determine which Hosting and Collective versions should be composed. That selection belongs to the appropriate orchestration and delivery configuration.

# Hosting and Collective

Hosting and Collective are independent Strata work streams and independently versioned artifacts.

During Speculative, they are composed into one graph because each pull request receives a paired Hosting and Collective environment.

```text
Speculative
    │
    ├── Hosting
    └── Collective
```

After promotion, the artifacts may be versioned independently:

```text
Hosting@version
Collective@version
```

A prospective Stack explicitly composes the selected versions.

This preserves the distinction between:

```text
Speculative
    → one development graph

Prospective
    → independently versioned artifacts composed into a graph
```

# Centralized Workflows

The preferred location for shared promotion workflows is:

```text
amiasea/.github
```

This repository contains delivery machinery rather than Strata resource implementations.

Conceptually:

```text
amiasea/.github
├── .github/
│   └── workflows/
│       └── Strata delivery workflows
│
└── terraform/
    └── delivery/
        └── strata/
            ├── speculative/
            └── prospective/
```

The Strata repository contains the Terraform implementations being delivered:

```text
strata/
└── terraform/
    ├── hosting/
    └── collective/
```

Centralizing delivery machinery permits common execution conventions, authentication, Terraform invocation, configuration assembly, and cleanup behavior without making the Strata repository responsible for maintaining Amiasea-specific delivery workflows.

The workflow nevertheless receives explicit execution context identifying the requested operation and revision.

# Reusable Workflows

Where appropriate, `amiasea/.github` may expose reusable workflows for bounded execution operations.

Examples include:

```text
speculative-workspace-create
speculative-workspace-run
speculative-workspace-update
prospective-realize
prospective-validate
terraform-execute
```

Reusable workflows should expose execution parameters rather than promotional policy.

The caller supplies the operation and execution context established by the orchestration system.

# Workflow Inputs

Inputs identify the operation and context necessary to perform it.

Typical inputs may include:

* pull-request identity;
* Strata revision;
* promotional stage;
* Hosting environment identity;
* Collective environment identity;
* HCP Terraform workspace identity;
* operation type; and
* validation parameters.

Inputs representing delivery state are not authoritative merely because they were supplied to the workflow.

The orchestration layer establishes the relevant state before dispatch.

# Workflow Results

Workflow execution produces observable events.

For example:

```text
workflow dispatched
    ↓
workflow started
    ↓
workflow completed
```

A Terraform operation may additionally produce:

```text
HCP Terraform run started
    ↓
HCP Terraform run completed
    ↓
workspace notification
```

The Amiasea API consumes these events and reconciles delivery state.

A successful workflow or Terraform run means that the requested execution completed successfully. It does not, by itself, establish promotional eligibility or promotion.

# Failure

Execution failure is an observation.

```text
workflow failure
    ↓
GitHub event
    ↓
Amiasea API
    ↓
delivery-state reconciliation
```

For HCP Terraform execution:

```text
Terraform failure
    ↓
workspace notification
    ↓
Amiasea API
```

The workflow does not determine the larger promotional consequence of failure.

That remains an orchestration concern.

# Cleanup

Cleanup workflows may remove or reset ephemeral Speculative realizations.

```text
pull-request lifecycle ends
        ↓
cleanup decision
        ↓
cleanup workflow
        ↓
realization removed or reset
        ↓
capacity event
```

The workflow performs the requested cleanup operation.

It does not decide when a pull request has ended or when capacity may be reassigned.

The capacity system determines when the resulting environment is safe and available again.

# Capacity

Workflows do not own Speculative capacity.

The capacity system determines whether an available paired environment exists.

```text
capacity decision
    ↓
Speculative slot assignment
    ↓
workflow
    ↓
execution
```

A workflow does not independently select an environment, allocate capacity, or expand the capacity pool.

It consumes the execution context established by the orchestration system.

A Speculative slot consists of paired Hosting and Collective environments with the same capacity assignment.

```text
Speculative slot 03
├── Hosting
└── Collective
```

The corresponding resource groups may carry a shared slot identifier through their platform metadata.

# Event Boundary

Workflows participate in the event system but do not own event coordination.

The primary execution loop is:

```text
GitHub / HCP Terraform
        ↓
events
        ↓
Amiasea API
        ↓
decision
        ↓
GitHub workflow
        ↓
execution
        ↓
GitHub / HCP Terraform
```

The API does not poll GitHub.

The API does not poll HCP Terraform workspaces.

Workflows do not poll the API for orchestration state.

The systems react to events emitted by the systems performing the work.

> **The event loop is driven by the systems that perform the work, not by a polling coordinator.**

# Security Boundary

Workflows execute with only the authority required for their operation.

Credentials, OIDC identity, Terraform credentials, and other execution context are supplied through the delivery architecture.

A centralized workflow does not receive unrestricted authority over Strata merely because it is shared.

Execution authority remains scoped to the requested operation.

# Boundary

Promotion workflows are responsible for:

* receiving execution requests;
* establishing execution context;
* performing bounded delivery operations;
* invoking Terraform or other execution mechanisms; and
* producing execution results through the available event surfaces.

Promotion workflows are not responsible for:

* defining promotional semantics;
* determining eligibility;
* allocating capacity;
* selecting component versions;
* maintaining promotional state;
* monitoring systems through polling; or
* defining Strata resources.

> **Workflows are execution adapters between delivery decisions and execution systems.**

# Future Direction

The preferred architecture centralizes shared workflow implementation and delivery templates in `amiasea/.github` while keeping Strata implementation separate.

```text
amiasea/.github
    → delivery machinery

strata
    → Hosting and Collective Terraform implementations

HCP Terraform
    → workspace, configuration-version, run, and state execution
```

This keeps execution mechanics independent from Strata ontology while allowing GitHub and HCP Terraform to provide the event surfaces through which execution feeds the next orchestration decision.
