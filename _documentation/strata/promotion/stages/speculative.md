# Speculative Promotion

Speculative is the Strata promotional stage in which an independently developed Strata artifact is realized in a controlled context and evaluated before promotion into Prospective.

Speculative establishes confidence in an individual Strata lifecycle. It does not establish the composition of independently promoted Hosting and Collective artifacts.

> **Speculative proves an individual lifecycle; Prospective proves the composition.**

# Scope

Strata Hosting and Strata Collective are independently maintained work streams.

```text
strata-hosting
    ↓
Speculative
    ↓
Hosting artifact

strata-collective
    ↓
Speculative
    ↓
Collective artifact
```

Each lifecycle has its own source, Terraform execution, validation, and promotion state.

A successful Speculative lifecycle produces an independently identifiable artifact that may be consumed by Prospective.

The two lifecycles do not need to advance together.

# Candidate

A speculative candidate represents a proposed revision of a Strata lifecycle.

A candidate is associated with a source branch and its corresponding delivery context.

A pull request is the primary GitHub governance surface for a candidate, but it is not the definition of the candidate itself.

The candidate lifecycle may include:

```text
source change
    ↓
candidate
    ↓
validation
    ↓
promotion eligibility
    ↓
speculative realization
    ↓
artifact
```

GitHub events provide observations that cause the delivery machinery to reconsider candidate state.

The Amiasea API coordinates the resulting activity without polling GitHub or HCP Terraform.

# Speculative Realization

A speculative candidate may be realized against capacity established for the Speculative stage.

For Hosting, realization occurs within a Hosting environment.

For Collective, realization occurs within the corresponding Collective environment.

The realization context is capacity established by the Speculative delivery architecture. The candidate does not define or create the Strata hosting boundary.

```text
Strata Speculative
├── Slot 1
│   ├── Hosting
│   └── Collective
├── Slot 2
│   ├── Hosting
│   └── Collective
└── ...
```

A candidate consumes an available realization context rather than redefining the hosting model.

# Capacity

Speculative capacity is finite.

A candidate may request a realization context and remain pending until capacity becomes available.

```text
candidate request
       ↓
capacity system
       ↓
available?
   ├── yes → assignment
   └── no  → waiting
```

A successful assignment provides the paired Hosting and Collective environments belonging to the same capacity slot.

The candidate observes availability rather than the mechanism by which that availability is produced.

Capacity management is defined in:

`../orchestration/capacity.md`

# Reservation

A candidate does not receive capacity merely because capacity exists.

Capacity is associated with a candidate when the applicable promotion conditions permit realization.

Once assigned, the realization context may remain associated with the candidate across revisions until the candidate lifecycle ends.

A new commit therefore does not inherently create a new environment or reservation.

Reservation and allocation are implementation responsibilities of the promotion machinery.

# Validation

Speculative validation establishes confidence in an individual lifecycle.

Validation may include:

* Terraform validation;
* infrastructure planning;
* repository and policy checks;
* realization tests;
* representative workload compatibility; and
* other lifecycle-specific checks.

The validation set may differ between Hosting and Collective.

```text
Hosting Speculative
    └── Hosting validation

Collective Speculative
    └── Collective validation
```

Speculative validation does not establish whether independently promoted Hosting and Collective artifacts are compatible with one another. That is a Prospective concern.

# Representative Workloads

Strata may use an accepted Kitting release as a representative workload when evaluating the hosting model.

The Kitting release remains part of Kitting's own promotional lifecycle.

```text
Kitting
    ↓
accepted release
    ↓
Strata Speculative
    ↓
hosting compatibility test
```

This is a consumption relationship, not a promotion relationship.

The workload does not become a Strata candidate.

> **Strata tests its hosting model against accepted workloads; those workloads do not enter Strata promotion.**

# Event-Driven Lifecycle

Speculative promotion is coordinated through events rather than polling.

GitHub provides events for source, pull-request, review, and workflow activity.

HCP Terraform provides execution notifications for Terraform activity.

Conceptually:

```text
GitHub / HCP Terraform
        ↓
event
        ↓
Amiasea API
        ↓
candidate / capacity / promotion evaluation
        ↓
GitHub workflow
        ↓
execution
        ↓
GitHub / HCP Terraform event
```

The API does not continuously query GitHub or HCP Terraform to determine whether a candidate or execution has changed.

An event causes the relevant delivery state to be evaluated.

The detailed event vocabulary and execution mechanisms are defined separately.

# Promotion

A successful Speculative lifecycle produces a promotable artifact.

For an artifact represented through the Private Module Registry:

```text
source
    ↓
Speculative
    ↓
validated artifact
    ↓
PMR version
```

The artifact is independently identifiable and can subsequently be selected by Prospective.

Promotion does not imply that the artifact has been correlated with another Strata lifecycle.

That correlation occurs in Prospective.

# Cleanup

Speculative realization is temporary delivery capacity rather than a permanent representation of the promoted artifact.

When a candidate lifecycle ends:

```text
candidate lifecycle ends
        ↓
cleanup requested
        ↓
realization removed or reset
        ↓
capacity becomes available
```

The mechanism used to clean the realization is not part of the Speculative semantic contract.

The capacity system determines when the realization is safe to assign again.

# Orchestration Boundary

Speculative defines the meaning and lifecycle of the promotional stage.

It does not define the implementation of the machinery that operates it.

Those responsibilities are documented separately:

* `../orchestration/capacity.md` — Speculative capacity
* `../orchestration/events.md` — delivery events
* `../orchestration/roles.md` — orchestration responsibilities
* `../orchestration/workflows.md` — execution mechanisms

The Amiasea API provides the platform boundary through which Strata promotion is coordinated.

GitHub provides source, governance, workflow execution, and event mechanisms.

HCP Terraform provides workspace execution and Terraform state.

These systems cooperate without any one of them becoming the semantic definition of Speculative.

# Relationship to Prospective

Speculative and Prospective have distinct responsibilities.

```text
Speculative
    ↓
independently promoted artifact
    ↓
Prospective
    ↓
selected artifacts
    ↓
component graph
```

Speculative establishes confidence in an individual lifecycle.

Prospective selects independently promoted artifacts and validates their composition.

A Hosting artifact may therefore advance while Collective remains unchanged, or vice versa.

Prospective explicitly selects the versions that are correlated.

# Boundary

Speculative is responsible for:

* evaluating an individual Strata candidate;
* realizing that candidate in an appropriate speculative context;
* performing lifecycle-specific validation; and
* producing an independently promotable artifact.

Speculative does not define:

* cross-lifecycle component composition;
* Prospective correlation;
* Operative promotion;
* application promotion;
* capacity-management implementation;
* orchestration roles;
* workflow implementation; or
* provider-specific realization mechanics.

> **Speculative independently validates and promotes a Strata lifecycle; Prospective determines whether independently promoted lifecycles form a valid composition.**
