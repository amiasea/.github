# Strata Promotion Roles

This document defines the roles through which Strata promotion is coordinated.

A role describes a responsibility. It does not imply a separate service, process, repository, or deployment. The Amiasea API may perform multiple roles.

> **Roles describe responsibility; implementations provide the mechanism.**

## Promotion Orchestrator

The Promotion Orchestrator coordinates Strata promotional activity.

It consumes logical events, evaluates the applicable promotional state, and determines whether an action is required.

The role may:

* evaluate candidate eligibility;
* request or consume capacity;
* coordinate reservations;
* authorize execution;
* dispatch workflows; and
* reconcile reported execution results.

It does not execute Terraform and does not define the semantics of a promotional stage.

```text
events
   ↓
Promotion Orchestrator
   ├── capacity decision
   ├── promotion decision
   └── execution request
```

The Amiasea API is the initial implementation boundary for this role.

## Speculative Capacity Manager

The Speculative Capacity Manager (SCM) manages the physical capacity available for Speculative realization.

Its capacity domain is:

```text
Speculative
├── Hosting capacity
└── Collective capacity
```

The SCM determines the configured capacity shape, including the number of environments that may be established and the applicable capacity bounds.

It also determines which eligible candidate can be assigned to available capacity.

The SCM may establish additional capacity when required, but capacity growth is not necessarily synchronous with a request. Capacity may also be established proactively.

```text
candidate request
       ↓
      SCM
       │
       ├── available
       │
       └── pending
             │
             └── capacity may be established
```

The mechanism used to create, destroy, or otherwise adjust capacity is opaque to consumers.

A consumer knows only whether an appropriate environment has become available.

> **The SCM manages capacity; consumers do not need to know how capacity became available.**

The detailed capacity contract is defined in `capacity.md`.

## Candidate and Eligibility

Candidate management and promotion eligibility are delivery responsibilities rather than necessarily independent components.

A speculative candidate is identified primarily by its feature branch and current revision.

A pull request is a governance and event surface for that candidate, not the candidate's identity.

The orchestration system may maintain:

* candidate identity;
* current revision;
* associated workspace;
* lifecycle state;
* promotion eligibility; and
* environment assignment.

Eligibility determines whether a candidate may proceed.

```text
candidate state
      +
GitHub governance
      +
validation results
      ↓
promotion eligibility
```

Eligibility and capacity are independent:

```text
eligible
   ≠
capacity available
```

An eligible candidate may therefore remain pending while waiting for capacity.

## Reservation

Reservation establishes the relationship between a candidate and an available Speculative environment.

```text
candidate
    ↕
environment
```

Reservation is distinct from capacity establishment.

The SCM determines available capacity. The orchestration system associates that capacity with candidates according to the applicable stage semantics.

For a candidate with a persistent Speculative realization, subsequent revisions continue to use its existing assignment rather than automatically acquiring a new environment.

The stage definition determines when the reservation is released.

## Artifact Correlation

Artifact Correlation is primarily a Prospective responsibility.

It selects independently promoted Hosting and Collective artifacts and establishes their relationship within a Prospective component graph.

```text
Hosting artifact
       +
Collective artifact
       ↓
component graph
```

The role does not merge the independent promotional lifecycles.

Prospective defines the semantics of the resulting composition.

## Execution Dispatcher

The Execution Dispatcher turns an orchestration decision into an executable workflow request.

```text
orchestration decision
        ↓
Execution Dispatcher
        ↓
GitHub workflow
        ↓
Terraform / HCP Terraform
```

The dispatcher supplies the context required by the workflow, such as candidate identity, workspace, environment assignment, or requested operation.

It does not implement Terraform execution.

## Execution Observer

Execution results are returned through the event systems of the participating platforms.

GitHub provides workflow events and HCP Terraform workspaces provide workspace notification events.

The Execution Observer associates those events with the relevant delivery operation and updates orchestration state.

```text
GitHub / HCP Terraform
          ↓
        events
          ↓
Execution Observer
          ↓
delivery state
```

The API does not poll either system to discover execution results.

> **Execution is observed through emitted events, not discovered through polling.**

## Event Handling

Event handling is a responsibility of the API control plane rather than an independent monitoring system.

External events are received from systems such as:

* GitHub;
* HCP Terraform workspaces; and
* other participating platform mechanisms.

They may be normalized into logical delivery events before being evaluated by the applicable role.

```text
external event
      ↓
Amiasea API
      ↓
logical event
      ↓
applicable role
```

The event vocabulary and event-to-role relationships are defined in `events.md`.

## Role Relationships

The primary orchestration relationship is:

```text
GitHub / HCP events
        ↓
Amiasea API
        ↓
Promotion Orchestrator
        │
        ├── candidate / eligibility
        │
        ├── Speculative Capacity Manager
        │
        ├── reservation
        │
        └── Execution Dispatcher
                    ↓
              GitHub workflow
                    ↓
             Terraform / HCP
                    ↓
             emitted events
```

Prospective additionally uses Artifact Correlation:

```text
Hosting artifact
       +
Collective artifact
       ↓
Artifact Correlation
       ↓
Prospective component graph
```

These relationships describe responsibilities, not deployment boundaries.

## Implementation Boundary

The Amiasea API is the primary implementation boundary for these orchestration roles.

A single API implementation may therefore contain:

```text
Amiasea API
├── Promotion Orchestrator
├── Speculative Capacity Manager
├── candidate / eligibility management
├── reservation management
├── Artifact Correlation
├── Execution Dispatcher
└── Execution Observer
```

These roles should remain semantically distinct even when implemented together.

No role requires a dedicated service unless implementation concerns eventually justify one.

## Boundaries

These roles do not own:

* the Strata ontology;
* Terraform state;
* HCP Terraform execution;
* GitHub repository state;
* GitHub governance policy;
* workflow execution;
* Kubernetes autoscaling; or
* application delivery.

They coordinate those systems according to the promotional semantics defined by Strata.

> **The roles coordinate promotion; they do not redefine the systems or domains being promoted.**
