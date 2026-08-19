I’d substantially tighten this now that we’ve established the actual architecture: **GitHub and HCP Workspaces are event sources; the API receives events; nothing polls.** The old version still describes a generic orchestration/event system and gives too much weight to internal capacity events.

The key distinction I’d preserve is:

* **External events** — emitted by GitHub or HCP Terraform.
* **Logical events** — Amiasea's interpretation of those observations.
* **Actions** — API decisions that cause GitHub/workflow activity.
* **State** — what the API knows to be true.

Here is the updated document.

# Strata Promotion Events

Events are the signals through which Strata promotion becomes observable to the delivery system.

Strata promotion is event-driven. GitHub and HCP Terraform provide the primary external event sources, while the Amiasea API interprets those events and coordinates subsequent action.

The API does not poll GitHub or HCP Terraform for changes.

GitHub workflows do not poll either system as part of promotion orchestration.

> **Events cause the delivery system to reconsider state; they do not require the delivery system to continuously monitor it.**

# Event Sources

The principal event sources are:

```text
GitHub
    ↓
repository, pull request, review, and workflow events

HCP Terraform
    ↓
workspace notification events

Amiasea API
    ↓
logical delivery events
```

GitHub is the primary source for source-control and workflow activity.

HCP Terraform Workspaces provide execution-state notifications for Terraform operations.

The Amiasea API consumes these observations and may emit logical events representing delivery state or decisions.

# GitHub Events

GitHub provides events describing source and governance activity.

Relevant events include:

* branch creation;
* branch deletion;
* branch update;
* pull request opened;
* pull request reopened;
* pull request synchronized;
* pull request closed;
* pull request merged;
* pull request review submitted;
* pull request review dismissed;
* workflow run requested;
* workflow run started;
* workflow run completed; and
* other repository events required by the delivery lifecycle.

These are GitHub events, not Strata semantic states.

For example:

```text
GitHub:
    pull_request.synchronize

logical interpretation:

    candidate revision changed
```

The logical interpretation belongs to the Strata delivery model.

# HCP Terraform Events

HCP Terraform Workspaces provide notifications for workspace and Terraform execution activity.

Relevant notifications may include events associated with:

* Terraform runs;
* run completion;
* run failure;
* run cancellation;
* workspace state changes; and
* other workspace notifications required by the delivery lifecycle.

These notifications allow the delivery system to react to Terraform execution without polling the workspace.

Conceptually:

```text
HCP Terraform Workspace
        ↓
notification
        ↓
Amiasea API
        ↓
logical delivery event
```

HCP Terraform remains authoritative for Terraform execution and workspace state.

The API interprets those notifications in the context of the delivery operation that produced them.

# Logical Events

Logical events describe delivery concepts derived from external observations or established delivery state.

Examples include:

* candidate created;
* candidate revision changed;
* promotion proposed;
* candidate became eligible;
* candidate became ineligible;
* capacity requested;
* capacity became available;
* candidate assigned;
* execution requested;
* execution completed;
* execution failed;
* candidate cleanup requested;
* candidate released;
* artifact became available;
* component correlation requested; and
* component graph established.

A logical event does not require a corresponding external webhook.

```text
external event
    ↓
logical interpretation
    ↓
delivery decision
```

Logical events provide the vocabulary through which the API reasons about delivery without exposing provider-specific mechanics to the rest of the system.

# Candidate Events

A speculative candidate is a branch-based unit of speculative delivery.

Candidate state is derived from events concerning its source branch, pull request, validation, and assigned capacity.

A typical sequence is:

```text
branch created
    ↓
candidate created

branch updated
    ↓
candidate revision changed

PR opened
    ↓
promotion proposed

required conditions satisfied
    ↓
candidate eligible

capacity available
    ↓
candidate assigned

execution completed
    ↓
candidate realization updated

candidate lifecycle ended
    ↓
cleanup requested
```

A pull request is therefore an important governance surface but is not itself the candidate.

A new commit changes the candidate revision rather than creating a new candidate.

# Promotion Proposal

A pull request into the applicable promotion branch represents a proposal to promote a candidate.

The relevant GitHub events provide the observations required to evaluate that proposal.

For example:

```text
PR opened
PR synchronized
review submitted
review dismissed
workflow completed
        ↓
promotion state evaluation
```

The API evaluates those observations against the current candidate state and applicable promotion conditions.

A GitHub event does not itself authorize promotion.

# Candidate Request

A candidate request is a logical request for the capacity required to realize an eligible candidate.

```text
eligible candidate
    ↓
candidate request
    ↓
capacity evaluation
```

A request does not imply that capacity is immediately available.

If capacity is unavailable, the candidate remains pending until a subsequent event indicates that the relevant capacity can be assigned.

The candidate therefore does not poll for capacity.

```text
candidate request
    ↓
pending
    ...
capacity available
    ↓
candidate may proceed
```

# Capacity Events

Capacity events describe meaningful changes in the availability or assignment of speculative environments.

Examples include:

* capacity requested;
* capacity became available;
* capacity assigned;
* capacity released; and
* capacity became unavailable.

Internal infrastructure operations do not need to become promotion events.

For example, the delivery system does not need to expose:

```text
Terraform plan
    ↓
Terraform apply
    ↓
resource group creation
    ↓
resource initialization
```

as separate promotion events.

The meaningful boundary is:

```text
capacity unavailable
        ↓
capacity becomes available
```

Capacity mechanics remain behind the capacity contract defined in `capacity.md`.

# Assignment Events

An assignment establishes the relationship between a candidate and available capacity.

```text
eligible candidate
        +
available capacity
        ↓
assignment
```

An assignment may identify:

* candidate;
* capacity type;
* environment identity; and
* execution context.

The resulting assignment becomes delivery state.

A workflow consumes the established assignment rather than independently selecting capacity.

# Workflow Events

GitHub Actions provides events describing workflow execution.

For example:

```text
workflow started
workflow completed
workflow failed
workflow cancelled
```

A workflow completion may produce a logical delivery interpretation:

```text
GitHub workflow completed
        ↓
execution completed
```

or:

```text
GitHub workflow failed
        ↓
execution failed
```

The workflow does not need to call the API to report its result.

GitHub remains the event source:

```text
Amiasea API
    ↓
GitHub workflow
    ↓
execution
    ↓
GitHub event
    ↓
Amiasea API
```

This is event-driven feedback, not polling.

# Execution Events

Execution events describe the result of an operation initiated by the delivery system.

An operation may involve GitHub Actions invoking Terraform against an HCP Terraform Workspace.

The API does not need to observe the operation continuously.

Instead:

```text
execution requested
        ↓
GitHub workflow
        ↓
HCP Terraform
        ↓
notification / workflow event
        ↓
execution result
```

The resulting event is correlated with the operation that produced it.

# Cleanup Events

Cleanup begins when the candidate lifecycle no longer requires its assigned environment.

Relevant logical events include:

* candidate lifecycle ended;
* cleanup requested;
* cleanup completed; and
* capacity released.

A typical sequence is:

```text
candidate lifecycle ended
    ↓
cleanup requested
    ↓
workflow execution
    ↓
execution completed
    ↓
capacity released
    ↓
capacity available
```

The environment is not considered available until the capacity system establishes that it is safe for reuse.

# Prospective Events

Prospective introduces events associated with artifact composition.

Examples include:

* artifact promoted;
* artifact version available;
* component correlation requested;
* component graph established;
* correlation validation completed;
* correlation failed; and
* Prospective composition eligible for Operative.

For example:

```text
Hosting artifact available
        +
Collective artifact available
        ↓
correlation requested
        ↓
component graph established
        ↓
validation completed
```

The semantic lifecycle is defined in `stages/prospective.md`.

The event model provides the signals through which that lifecycle is coordinated.

# Event Flow

The general promotion flow is:

```text
GitHub / HCP Terraform
        ↓
external event
        ↓
Amiasea API
        ↓
logical interpretation
        ↓
delivery state / decision
        ↓
GitHub workflow
        ↓
GitHub / HCP Terraform event
```

The loop is therefore event-driven.

There is no requirement for:

```text
API → poll GitHub
API → poll HCP Terraform
workflow → poll API
workflow → poll HCP Terraform
```

# State and Events

Events and state have different responsibilities.

State answers:

> What is true now?

Events answer:

> What happened or became relevant that should cause the system to reconsider its state?

For example:

```text
State:
    candidate = C
    status = eligible
    environment = unassigned

Event:
    capacity became available

Evaluation:
    assign C to available capacity
```

The resulting assignment becomes state.

The event is a trigger for evaluation rather than the authoritative representation of that assignment.

# Event Ordering

Events do not establish a globally ordered history of the delivery system.

GitHub and HCP Terraform may report related activity independently.

For example:

```text
GitHub:
    workflow completed

HCP Terraform:
    run completed
```

Both may describe aspects of the same execution.

The API therefore evaluates incoming events against current delivery state rather than assuming that events arrive exactly once or in a universal order.

# Idempotency

External events may be duplicated, delayed, or delivered after related events have already been processed.

Event handling must therefore be idempotent.

For example:

```text
pull_request.synchronize
        ↓
candidate revision changed
```

Receiving the same event again must not create a second candidate revision.

Likewise:

```text
capacity available
        ↓
assignment
```

must not create a second assignment when the capacity has already been assigned.

The general pattern is:

```text
event
    ↓
current state
    ↓
evaluate
    ↓
required transition
```

An event is therefore a signal to reconsider state, not an unconditional mutation command.

# Event Correlation

Events must contain or resolve sufficient information to associate an observation with the delivery operation it concerns.

Depending on the source, correlation may use information such as:

* repository;
* branch;
* pull request;
* commit or revision;
* workflow run;
* workflow invocation;
* HCP Terraform workspace;
* Terraform run;
* candidate;
* capacity assignment; or
* promotion operation.

Correlation allows multiple external event streams to describe one delivery operation without requiring those systems to share an internal state model.

# Event Boundaries

The event architecture separates observation from interpretation and action.

```text
External system
    ↓
external event
    ↓
Amiasea API
    ↓
logical interpretation
    ↓
delivery decision
    ↓
GitHub workflow
    ↓
execution
```

GitHub and HCP Terraform remain authoritative for the state they own.

The API becomes the coordination boundary for the delivery state that spans those systems.

# Boundary

The event model does not own:

* Strata infrastructure;
* Terraform state;
* HCP Terraform execution state;
* GitHub repository policy;
* speculative capacity;
* candidate allocation policy;
* workflow implementation; or
* promotional semantics.

Those responsibilities belong to their respective systems and documents.

The event model defines how meaningful observations enter and move through the delivery system.

> **GitHub and HCP Terraform emit the observations; the Amiasea API interprets them and turns them into the next delivery action.**
