# Meta Model

The Amiasea engineering model is a higher-order model for engineering work.

It defines the concepts, responsibilities, work streams, delivery mechanisms, promotional lifecycles, and evidence through which engineering work can be established, delivered, operated, and evolved.

Amiasea is therefore not merely an application platform, a collection of Terraform configurations, a CI/CD system, or an organizational structure.

It is an **engineering model**.

The infrastructure, repositories, Terraform workspaces, HCP Terraform projects, GitHub workflows, APIs, cloud resources, and other implementation mechanisms are realizations of the model.

> **The engineering model defines the form of engineering work; its infrastructure and machinery realize that form.**

## The Engineering Model as a Higher-Order System

The engineering model describes how engineering itself is performed.

At the ordinary level, the model enables an application solution to move from engineering change to an operative production state.

At the meta level, the engineering model can itself be treated as an engineered subject.

Conceptually:

```text
Engineering Model
        │
        ├── defines engineering work
        │
        ├── establishes delivery machinery
        │
        ├── establishes hosting
        │
        ├── establishes application delivery
        │
        └── provides evidence of engineering health
```

This creates a distinction between:

1. **the engineering model** — the higher-order system that defines how engineering is performed;
2. **engineering work** — changes made within that model;
3. **delivery** — the mechanisms through which selected engineering work is established, promoted, and operated; and
4. **application solutions** — concrete domain capabilities delivered through the model.

Delivery is therefore an aspect of the engineering model rather than the entirety of the engineering model.

## The Engineering Model Can Be Engineered

The engineering model itself can change.

For example, a change might introduce:

* a new promotional stage;
* a new capacity-management mechanism;
* a new access relationship;
* a new orchestration capability;
* a new developer workflow;
* a new validation requirement;
* a new form of engineering evidence;
* a change to Strata hosting;
* a change to Kitting delivery; or
* a new concept within the engineering ontology.

These are not merely implementation changes.

They may represent changes to **how engineering is performed**.

The model therefore needs a way to distinguish between:

```text
implementation change
        │
        └── changes how an existing model concept is realized

model change
        │
        └── changes the concepts, relationships,
            responsibilities, or behavior of engineering itself
```

The distinction is important because the second category can affect every subsequent piece of engineering work.

## Meta-Level Validation

A mature realization of Amiasea could validate the engineering model by using the engineering model.

That means a proposed change to the engineering model could be subjected to an end-to-end engineering scenario:

```text
Engineering-model change
        │
        ▼
Institutive changes
        │
        ▼
Strata changes
        │
        ▼
Kitting changes
        │
        ▼
Application solution change
        │
        ▼
Application reaches production
        │
        ▼
Application is tested
        │
        ▼
Engineering-model change accepted
```

The important property is that the test does not stop at:

> "Did the infrastructure deploy?"

It asks:

> **Can this version of the engineering model successfully perform the engineering work it exists to support?**

The engineering model is therefore validated by executing an instance of engineering through the model itself.

## Engineering Model Production State

The engineering model could, in principle, have its own release lifecycle and production state.

Its production state would not mean that the engineering model is simply another application deployed into an Azure resource group.

Instead, its production state would represent the **accepted version of the engineering model that the organization relies upon to perform engineering work**.

Conceptually:

```text
Engineering Model
        │
        ▼
development
        │
        ▼
validation
        │
        ▼
acceptance
        │
        ▼
production
```

The acceptance test for that production state could be the successful execution of a representative engineering scenario.

For example:

```text
Engineering Model Candidate
        │
        ▼
establish delivery machinery
        │
        ▼
establish Strata hosting
        │
        ▼
promote Strata
        │
        ▼
deliver Kitting workload
        │
        ▼
promote application solution
        │
        ▼
application reaches Operative
        │
        ▼
application behavior validated
```

A successful result demonstrates more than the correctness of individual Terraform configurations.

It demonstrates that the **engineering system as a whole remains capable of performing the process it defines**.

## A Potential Meta-Promotion Model

Amiasea does not currently need to give the engineering model itself a separate promotional environment hierarchy.

Such a system would require substantial additional infrastructure and could involve separate enterprise or control-plane instances in order to isolate one version of the engineering model from another.

The concept is nevertheless useful because it defines a possible future property of the model.

A hypothetical meta-promotion lifecycle might look like:

```text
Engineering Model

├── Speculative
│
├── Prospective
│
└── Operative
```

The distinction is not currently an implementation requirement.

It is a conceptual model for understanding what it would mean to test and promote the engineering model itself.

In such a system, a speculative engineering-model instance could contain its own:

* Institutive delivery machinery;
* Strata promotional process;
* Kitting promotional process;
* application solution;
* validation workloads; and
* observability.

The ultimate test would therefore be extraordinarily meta:

```text
A speculative engineering model
        │
        └── executes an engineering process
                │
                ├── establishes Strata
                │
                ├── promotes Strata
                │
                ├── establishes Kitting
                │
                ├── promotes Kitting
                │
                └── delivers an application
                         │
                         ▼
                     production
```

The engineering model would be using an instance of itself to prove that itself works.

This is a possible future capability, not a current requirement.

## Why Meta-Level Validation Matters

Without an executable validation model, changes to engineering methodology are often evaluated indirectly.

An architect might determine that:

* the topology is correct;
* the Terraform is valid;
* the workflow succeeds;
* the controls exist; and
* the documentation is consistent.

Yet none of those demonstrate that an engineer can actually use the resulting system successfully.

An end-to-end engineering-model validation creates a stronger acceptance criterion:

> **The model must be capable of executing the work it claims to support.**

This makes the engineering model falsifiable.

If a proposed change prevents a representative application from reaching its intended production state, the model has produced evidence that the change is incomplete, incompatible, or incorrect.

## Developer Ergonomics as an Architectural Concern

Meta-level validation also forces the engineering model to represent the experience of the engineer using it.

Enterprise architecture traditionally emphasizes the things the organization possesses:

* applications;
* infrastructure;
* subscriptions;
* identities;
* environments;
* dependencies;
* governance;
* controls; and
* integrations.

The engineering model adds another architectural subject:

> **The work an engineer must perform to cause the architecture to produce the intended result.**

The model can therefore simulate developer behavior.

For example:

```text
Developer
    │
    ├── creates change
    │
    ▼
GitHub
    │
    ▼
Delivery machinery
    │
    ▼
Strata environment
    │
    ▼
Application deployment
    │
    ▼
Validation
    │
    ▼
Promotion
    │
    ▼
Production
```

This makes developer ergonomics an architectural property rather than an implementation detail.

The model can ask:

* Can the developer discover what to do?
* How many actions are required?
* How many systems must the developer understand?
* How long must the developer wait?
* Which decisions are automated?
* Which decisions require intervention?
* Can the developer understand why a transition failed?
* Can the developer determine where their candidate is running?
* Can the developer recover from failure?
* Does the model hide infrastructure complexity as intended?
* Can the developer reproduce or diagnose the delivery process?

A model that technically works but requires unreasonable human interaction has evidence of an architectural deficiency.

> **An engineering model is not fully validated by infrastructure correctness if the engineer cannot effectively use it to perform engineering work.**

## Engineering Ergonomics

Developer ergonomics can therefore become an observable property of the engineering model.

Examples include:

```text
Developer action count
Time waiting for environment
Time waiting for validation
Number of manual interventions
Number of systems requiring direct interaction
Promotion failure recovery time
Number of unexplained failures
Environment allocation latency
Time from commit to Operative
```

These measures do not necessarily define success by themselves.

They provide evidence with which the engineering model can be evaluated and evolved.

## Engineering-Model Observability

Amiasea originally envisioned an observability surface through which delivered artifacts could be represented as enterprise domain capabilities.

That remains an important view.

However, the engineering model also creates a second observability domain:

> **Observability of the organization's capability to perform engineering.**

This is fundamentally different from application observability.

### Solution Observability

Solution observability asks:

> **What capabilities has the enterprise delivered, and what is the state of those capabilities?**

Conceptually:

```text
Enterprise
    │
    └── Domain
         │
         └── Capability
              │
              └── Application Solution
                   │
                   ├── version
                   ├── deployment
                   ├── environment
                   ├── dependencies
                   └── operational health
```

This view remains concerned with the delivered enterprise.

It can answer questions such as:

* What applications exist?
* Which business capabilities do they realize?
* Which release is Operative?
* Where is the capability deployed?
* What infrastructure does it depend upon?
* Is the capability healthy?
* What changed recently?

### Engineering-Model Observability

Engineering-model observability asks:

> **How capable is the organization at engineering and delivering those capabilities?**

Conceptually:

```text
Engineering Model
        │
        ├── Institutive
        │
        ├── Strata
        │
        └── Kitting
               │
               ▼
        Delivery System
               │
               ▼
             Evidence
               │
               ▼
       Engineering Health
```

The observable subjects are therefore not primarily applications.

They are **engineering capabilities**.

## Engineering Capability and Evidence

The following provides a useful initial vocabulary for engineering-model observability:

| Engineering capability | Possible evidence                            |
| ---------------------- | -------------------------------------------- |
| Candidate realization  | Time from commit → environment               |
| Speculative capacity   | Queue depth, allocation latency, utilization |
| Promotion              | Transition success/failure rate              |
| Validation             | Test completion and failure rates            |
| Delivery               | Commit → Operative duration                  |
| Recovery               | Failed promotion → recovery duration         |
| Developer ergonomics   | Actions, waits, interventions                |
| Infrastructure         | Strata capacity and health                   |
| Access                 | Authentication/trust failures                |
| Orchestration          | Workflow/API failure rates                   |
| Operative health       | Post-promotion behavior                      |
| Model evolution        | Regression rate after model changes          |

These are not merely dashboard metrics.

They provide evidence about whether the engineering model is fulfilling its intended responsibilities.

For example, an application taking forty-seven minutes to reach production may initially appear to be an application delivery problem.

Engineering-model observability can decompose that result:

```text
Application delivery
        │
        ├── Kitting realization       8m
        ├── environment allocation   2m
        ├── validation               14m
        ├── promotion approval        5m
        ├── workflow execution       11m
        └── orchestration delay       7m
```

The application event therefore becomes evidence about the health of the engineering model.

## Engineering Health

Engineering health is the observed condition of the engineering model's capabilities.

It can include:

* delivery throughput;
* promotion reliability;
* environment availability;
* capacity utilization;
* validation reliability;
* orchestration reliability;
* access reliability;
* recovery behavior;
* developer interaction cost;
* operative stability; and
* regression following model changes.

Engineering health should not be reduced to infrastructure health.

A healthy Azure resource does not necessarily imply a healthy engineering model.

Similarly, a successful Terraform run does not necessarily imply a successful engineering process.

The engineering model is healthy when its capabilities collectively produce the intended engineering outcomes.

## Evidence Across Promotional Stages

The meaning of evidence changes as engineering work progresses.

### Speculative

Speculative provides early evidence about whether a candidate can be realized.

Evidence may include:

* candidate realization;
* environment allocation;
* workflow execution;
* initial validation;
* resource consumption;
* capacity behavior;
* failure modes; and
* time-to-feedback.

The purpose is to determine whether the candidate is viable enough to proceed.

### Prospective

Prospective provides stronger evidence about whether an accepted candidate can operate correctly before becoming Operative.

Evidence may include:

* representative workload behavior;
* integration validation;
* compatibility;
* security and access behavior;
* operational characteristics;
* acceptance criteria; and
* accumulated validation evidence.

The purpose is to establish confidence for promotion.

### Operative

Operative provides evidence about the behavior of an accepted realization in its intended operating context.

Evidence may include:

* availability;
* performance;
* failures;
* resource consumption;
* operational events;
* user impact;
* degradation;
* drift;
* recovery behavior; and
* post-promotion stability.

The purpose is not merely to establish that the release deployed, but to determine whether the accepted realization continues to behave as intended.

## Engineering-Model Health Across Promotion

The same principle can be applied to the engineering model itself.

A future meta-level validation system could observe:

```text
Engineering-model candidate
        │
        ▼
Speculative evidence
        │
        ▼
Prospective evidence
        │
        ▼
Operative evidence
        │
        ▼
Engineering-model health
```

The evidence would describe the model's ability to perform engineering work.

For example:

```text
Speculative
    ├── Can the candidate environment be realized?
    ├── Can the delivery machinery execute?
    └── Can the representative workload be deployed?

Prospective
    ├── Can the complete delivery process be validated?
    ├── Are the expected transitions reliable?
    └── Is the developer experience acceptable?

Operative
    ├── Does the model continue to deliver reliably?
    ├── Are production outcomes healthy?
    └── Does the model remain operationally coherent?
```

This creates a distinction between **testing the implementation** and **testing the engineering capability produced by the implementation**.

## Observability as a Feedback Loop

Engineering-model observability creates a feedback loop between engineering work and the model that governs that work.

```text
Engineering Model
       │
       ▼
Engineering Work
       │
       ▼
Delivery
       │
       ▼
Observed Evidence
       │
       ▼
Analytics / Health
       │
       ▼
Engineering Model Evolution
       │
       └──────────────────────►
```

The model therefore becomes capable of learning from its own execution.

Evidence from real engineering work can reveal:

* unnecessary complexity;
* ineffective abstractions;
* capacity constraints;
* poor developer ergonomics;
* unreliable promotion mechanisms;
* inadequate validation;
* weak operational feedback;
* access problems;
* orchestration failures; and
* places where the ontology itself no longer corresponds well to engineering reality.

The purpose of observability is therefore not merely to produce dashboards.

It is to provide evidence with which the engineering model can be deliberately evolved.

## Standard Form for Engineering Work

A well-formed engineering model provides a standard format for introducing engineering change.

A proposed change can be understood through a consistent sequence:

```text
Engineering intent
        ↓
Engineering concept
        ↓
Work stream
        ↓
Delivery mechanism
        ↓
Promotional lifecycle
        ↓
Validation evidence
        ↓
Operational evidence
        ↓
Accepted state
```

This allows engineers and architects to ask the same questions for fundamentally different changes.

A new hosting capability, an API change, a promotion mechanism, a developer workflow, or an application solution can all be described in terms of:

* what is changing;
* which concept is affected;
* who owns that concept;
* how it is realized;
* how it is promoted;
* what evidence is required; and
* what constitutes acceptance.

The standard form makes the engineering model easier to reason about even as the model itself evolves.

## Architectural Ergonomics

The model also creates a challenge for enterprise architecture.

An enterprise architect cannot evaluate the architecture solely by examining its resulting infrastructure.

The architecture must be evaluated through the work that engineers perform against it.

This introduces an architectural dimension that can be described as **engineering ergonomics**.

An architectural proposal can therefore be evaluated by simulating:

```text
developer intent
        ↓
developer action
        ↓
delivery response
        ↓
infrastructure realization
        ↓
validation
        ↓
promotion
        ↓
production result
```

This exposes architectural characteristics that conventional diagrams may hide.

For example:

* repository complexity;
* coordination requirements;
* waiting time;
* manual intervention;
* discoverability;
* failure diagnosis;
* recovery;
* abstraction boundaries;
* required platform knowledge; and
* operational feedback.

The engineering model consequently makes the developer experience part of the architecture's observable behavior.

> **Architecture is not complete when the infrastructure exists; it is complete when an engineer can use the architecture to accomplish the work it was designed to support.**

## Solution Observability and Engineering Observability

The two observability domains are complementary.

```text
                         Amiasea
                            │
              ┌─────────────┴─────────────┐
              │                           │
       Solution View              Engineering View
              │                           │
       What have we                 How well can we
        delivered?                   deliver?
              │                           │
       Enterprise                 Engineering Model
       capabilities               capabilities
              │                           │
       Applications                 Delivery
              │                           │
       Operational                  Engineering
          health                       health
```

The Solution View describes the state of the enterprise's delivered capabilities.

The Engineering View describes the organization's capability to produce and maintain those capabilities.

Neither replaces the other.

Together they provide a more complete representation of the relationship between **what the enterprise has** and **how the enterprise is able to engineer it**.

## Evolution of the Engineering Model

The engineering model should not be treated as a static architecture document.

It is itself subject to engineering change.

A mature evolution cycle can therefore be understood as:

```text
Observe
   ↓
Identify limitation
   ↓
Propose model change
   ↓
Implement change
   ↓
Execute representative engineering scenario
   ↓
Collect evidence
   ↓
Evaluate developer and operational behavior
   ↓
Accept or reject model change
```

This provides a disciplined mechanism for evolving the model based on evidence rather than architectural preference alone.

A model change is successful when it improves or preserves the capabilities the engineering model is intended to provide.

## Recursive Vocabulary

The engineering model necessarily contains concepts that can appear at multiple levels.

For example:

* Speculative can describe a Strata stage;
* Speculative can describe a Kitting stage; and
* a future implementation could use Speculative to describe validation of the engineering model itself.

This does not make the vocabulary inherently ambiguous.

The subject of the promotion remains the important distinction.

```text
Strata Speculative
    → candidate hosting realization

Kitting Speculative
    → candidate application realization

Engineering-model Speculative
    → candidate engineering-model realization
```

The same vocabulary can therefore be reused at different semantic levels while retaining a well-defined subject.

The objective is not to eliminate recursive terminology.

The objective is to make the **level and subject of the term explicit**.

## The Meta Principle

The ultimate purpose of the meta model is to make the engineering model itself understandable, testable, observable, and evolvable.

The model should describe not only:

> **What engineering work produces.**

but also:

> **How engineering work is performed.**

and eventually:

> **How the organization knows that its way of performing engineering is working.**

This creates three connected perspectives:

```text
Enterprise Capability
        │
        │ What was delivered?
        ▼
Solution Observability


Engineering Capability
        │
        │ How well can we deliver?
        ▼
Engineering-Model Observability


Engineering Evolution
        │
        │ How should the model change?
        ▼
Model Development and Validation
```

The three perspectives form a continuous system:

```text
Engineering Model
       │
       ▼
Engineering Work
       │
       ▼
Delivered Capability
       │
       ▼
Observed Outcomes
       │
       ├── Solution Health
       │
       └── Engineering Health
                │
                ▼
        Model Evolution
                │
                └──────────────► Engineering Model
```

> **The engineering model defines the form of engineering, delivery realizes that form, solutions demonstrate its capability, observability provides evidence of its effectiveness, and that evidence informs the model's evolution.**

## Current Position

Amiasea does not currently require a separate meta-promotional environment in which the engineering model is itself deployed as an isolated enterprise instance.

The concept is retained because it provides a useful architectural boundary for understanding the future possibilities of the model.

The immediate objective is simpler:

* establish the engineering model;
* establish Delivery;
* establish Institutive, Strata, and Kitting as coherent work streams;
* establish their independent promotional lifecycles;
* deliver real application solutions through the model;
* collect evidence about the resulting engineering process; and
* use that evidence to evolve the model.

A future system could make the engineering model itself fully executable and promotable.

Whether that is ever implemented is less important than recognizing the conceptual possibility.

The model is already designed so that its own effectiveness can be evaluated through the engineering work it enables.

> **The strongest validation of an engineering model is the successful engineering of something real through that model.**
