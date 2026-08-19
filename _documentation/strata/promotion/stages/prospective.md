# Speculative Promotion

Speculative is the Strata promotional stage in which a pull request is evaluated as a complete Hosting and Collective composition before its independently versioned artifacts are promoted for Prospective composition.

> **Speculative proves the change as a whole; Prospective proves the promoted artifacts as a composition.**

# Purpose

Strata Hosting and Strata Collective are developed within the same Strata change graph.

A pull request may modify either or both:

```text
strata/
└── terraform/
    ├── hosting/
    └── collective/
```

Speculative evaluates the pull request as one graph:

```text
Pull request
    │
    ▼
Speculative
    ├── Hosting
    └── Collective
```

This allows cross-component behavior to be evaluated before independently versioned artifacts are promoted.

The Speculative graph does not establish a permanent coupling between the resulting artifacts. Hosting and Collective may subsequently be promoted and versioned independently.

# Speculative Environment

Each pull request is assigned a paired Speculative environment.

A Speculative environment consists of one Hosting environment and one Collective environment established as a single capacity slot.

```text
Speculative slot 03
├── Hosting environment
└── Collective environment
```

The paired environments share the same capacity assignment and may be identified through a common slot number and resource-group metadata.

The assignment provides the concrete environment identities required by the Speculative Terraform configuration:

```text
hosting_environment_id
collective_environment_id
```

The pair represents the execution environment for the pull request's complete Strata graph.

# Speculative Workspace

The Speculative graph is evaluated through an HCP Terraform workspace associated with the pull request's lifecycle.

The workspace is not VCS-connected.

The workspace receives configuration versions assembled from:

```text
Strata pull-request revision
        +
Speculative workspace harness
        +
assigned environment values
```

The Speculative workspace harness is maintained in:

`amiasea/.github/terraform/delivery/strata/speculative`

The delivery workflow combines the harness with the Terraform content from the pull request and supplies the assigned environment identities.

The resulting configuration represents:

```text
Speculative workspace
├── Hosting
└── Collective
```

The workspace therefore evaluates the actual pull-request graph rather than independently evaluating the two components.

# Configuration Lifecycle

The Speculative workspace persists for the lifecycle of the pull request.

When a pull request receives a new commit, the delivery system creates a new configuration version for the existing workspace.

```text
Pull request revision 1
        ↓
configuration version 1
        ↓
speculative run


Pull request revision 2
        ↓
configuration version 2
        ↓
speculative run
```

The workspace and its execution history therefore remain associated with the pull request while each revision receives its own configuration version and run.

The workspace does not need to obtain configuration through VCS integration.

# Workspace Harness

The Speculative workspace harness provides the root Terraform configuration required to execute the Strata graph.

It establishes the providers, declares the inputs supplied by the delivery system, and maps those inputs to the Hosting and Collective implementations.

Conceptually:

```text
Speculative harness
├── providers
├── environment inputs
└── module composition
       ├── Hosting
       └── Collective
```

The harness is delivery machinery rather than part of the Strata implementation itself.

The Strata Terraform configuration remains the source of the Hosting and Collective implementations.

# Speculative Capacity

Speculative capacity is established independently of the pull-request lifecycle.

Capacity consists of paired Hosting and Collective environments:

```text
amiasea-speculative
├── Speculative slot 01
│   ├── Hosting
│   └── Collective
├── Speculative slot 02
│   ├── Hosting
│   └── Collective
└── ...
```

The Speculative Capacity Manager assigns an available slot to an eligible pull request.

The slot establishes both environment identities.

A pull request therefore does not independently reserve a Hosting environment and a Collective environment.

It receives one paired Speculative assignment.

# Validation

Speculative validation concerns the complete change represented by the pull request.

It may include:

* Hosting behavior;
* Collective behavior;
* Hosting and Collective interfaces;
* shared configuration;
* identity and trust relationships;
* cross-component infrastructure behavior;
* topology assumptions; and
* representative workload behavior.

Speculative is therefore the appropriate stage for validating changes that require both components to exist together.

```text
Pull request
      ↓
paired environment
      ↓
complete Strata graph
      ↓
Speculative validation
```

The exact validation mechanisms are implementation concerns.

The semantic responsibility is evaluation of the proposed Strata change before independent artifact promotion.

# Independent Artifact Promotion

Successful Speculative evaluation does not create a single versioned Strata artifact.

Hosting and Collective remain independently versioned.

A change may produce:

```text
Hosting
    → new PMR version

Collective
    → unchanged
```

or:

```text
Hosting
    → unchanged

Collective
    → new PMR version
```

or:

```text
Hosting
    → new PMR version

Collective
    → new PMR version
```

The absence of a change to one component therefore does not require a new version of that component.

The independently promoted artifacts become available for Prospective composition.

# PMR Boundary

The Private Module Registry provides the exchange boundary between Speculative development and Prospective composition.

```text
Pull request
      ↓
Speculative graph
      ↓
independent promotion
      ↓
PMR
      ↓
Prospective composition
```

Speculative evaluates source changes directly from the pull-request revision.

Prospective consumes independently versioned artifacts from the PMR.

The PMR therefore separates development-time graph validation from artifact-level promotion and composition.

# Event-Driven Coordination

Speculative coordination is event-driven.

GitHub provides events for repository, pull request, review, and workflow activity.

HCP Terraform provides execution notifications for workspace activity.

```text
GitHub
    ↓
Amiasea API
    ↓
Speculative decision
    ↓
delivery workflow
    ↓
HCP Terraform
    ↓
workspace notification
    ↓
Amiasea API
```

The API does not poll GitHub or HCP Terraform to discover changes.

A new pull-request commit produces a new event. The API can then coordinate creation of a new configuration version for the existing Speculative workspace.

Execution results are likewise observed through the supported event mechanisms.

# Delivery Machinery

Speculative delivery machinery is maintained centrally in:

`amiasea/.github`

The Speculative workspace harness is maintained specifically in:

`amiasea/.github/terraform/delivery/strata/speculative`

The delivery workflow uses this harness together with the requested pull-request revision from the Strata repository.

Conceptually:

```text
amiasea/.github
├── delivery workflow
└── terraform/
    └── delivery/
        └── strata/
            └── speculative/
                └── workspace harness

strata
└── terraform/
    ├── hosting/
    └── collective/
```

This keeps delivery mechanics separate from the Terraform implementations being delivered.

The Strata repository does not need to contain Amiasea-specific workflow machinery merely to participate in Speculative promotion.

# Execution

The Amiasea API coordinates Speculative execution but does not directly execute Terraform.

```text
GitHub pull-request event
        ↓
Amiasea API
        ↓
Speculative assignment
        ↓
workflow dispatch
        ↓
delivery workflow
        ↓
configuration version
        ↓
HCP Terraform workspace
        ↓
speculative run
```

The workflow performs the bounded delivery operation.

It does not determine eligibility, select capacity, or define the Speculative semantics.

Execution results return through GitHub and HCP Terraform event mechanisms.

# Failure

Speculative execution failure is an observation.

```text
workflow failure
    ↓
GitHub event
    ↓
Amiasea API
    ↓
Speculative state evaluation
```

For HCP Terraform execution:

```text
Terraform failure
    ↓
HCP Terraform notification
    ↓
Amiasea API
```

The execution failure does not itself define the broader promotional consequence.

The appropriate orchestration responsibility determines whether the pull request remains in Speculative, requires another execution, becomes ineligible, or reaches another state.

# Cleanup

Speculative environments are ephemeral.

When the pull-request lifecycle no longer requires its Speculative realization, the orchestration system may dispatch cleanup.

```text
pull-request lifecycle ends
        ↓
cleanup decision
        ↓
cleanup workflow
        ↓
paired environment released
        ↓
Speculative slot available
```

The cleanup mechanism removes or resets the realization as required.

It does not independently determine when a pull request has completed its Speculative lifecycle.

Capacity becomes available only when the capacity system establishes that the paired environment is safe to reuse.

# Relationship to Prospective

Speculative and Prospective have different responsibilities.

Speculative evaluates a source change as a complete graph:

```text
Speculative
└── pull-request graph
    ├── Hosting
    └── Collective
```

Prospective consumes the resulting independently promoted artifacts:

```text
Prospective
└── component graph
    ├── Hosting@version
    └── Collective@version
```

The stages therefore establish two different forms of confidence.

```text
Speculative
    → does this change work as a Strata graph?

Prospective
    → do these selected promoted artifacts work as a composition?
```

Prospective is not another execution of the same Speculative workspace.

It is a distinct promotional context operating on versioned artifacts.

# Relationship to Kitting

Speculative may use an accepted Kitting release as a representative workload when validating the Strata graph.

This is a consumption relationship, not a promotion relationship.

```text
Kitting
    ↓
accepted release
    ↓
Speculative validation
```

The Kitting release remains governed by Kitting's own lifecycle.

It does not become part of Strata promotion merely because it is used as a validation workload.

# Promotion Boundary

A successful Speculative evaluation establishes that the pull-request change has satisfied the conditions required for independent artifact promotion.

```text
Pull request
    ↓
paired Speculative environment
    ↓
complete graph
    ↓
Speculative validation
    ↓
artifact promotion
    ├── Hosting version, if changed
    └── Collective version, if changed
```

Artifact promotion does not imply that the resulting versions have already been correlated for Prospective operation.

That correlation is established separately by Prospective.

# Boundary

Speculative is responsible for:

* evaluating a pull request as a complete Strata graph;
* using paired Hosting and Collective environments;
* establishing confidence in the proposed change;
* preserving the identity of the pull-request realization;
* supporting independent artifact promotion; and
* providing the promotional boundary between source changes and versioned artifacts.

Speculative does not define:

* the Hosting lifecycle independently;
* the Collective lifecycle independently;
* PMR version selection for Prospective;
* Prospective component correlation;
* Operative promotion;
* capacity-management implementation;
* workflow implementation;
* event transport; or
* the semantic definition of delivery machinery.

Those concerns belong to the respective Strata stages, orchestration systems, and platform delivery mechanisms.

> **Speculative evaluates the complete Strata change; independent artifacts emerge from that evaluation and are deliberately composed at Prospective.**
