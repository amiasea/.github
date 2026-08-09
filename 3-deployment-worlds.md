# The Three Engineering Worlds and Their Lifecycles

## Purpose

## 1. Enterprise Strata

### 1.1 Strata has an engineering-model lifecycle
### 1.2 The two meanings of deployment
### 1.3 Strata release identity
### 1.4 Promotion of an approved prospective release
### 1.5 Strata Stack registration
### 1.6 Why this model fits Strata
### 1.7 Strata composition

## 2. Enterprise Portfolio

### 2.1 Portfolio has a solution lifecycle
### 2.2 Portfolio development and evaluation
### 2.3 Portfolio prospective releases
### 2.4 Portfolio operational release
### 2.5 Portfolio Stack topology
### 2.6 Portfolio release identity
### 2.7 Promotion of an approved prospective release
### 2.8 Why this model fits Portfolio
### 2.9 Portfolio composition

## 3. Preview Environments

### 3.1 Preview Environments have an application/PR lifecycle
### 3.2 Preview creation and evaluation
### 3.3 Preview environment identity
### 3.4 Preview deployment
### 3.5 Preview lifecycle and cleanup
### 3.6 Why this model fits Preview Environments
### 3.7 Preview composition

## 4. Relationships Between the Engineering Worlds

### 4.1 Strata as a platform-level dependency
### 4.2 Portfolio as a solution-level dependency
### 4.3 Preview Environments as an application-level concern
### 4.4 Cross-world release identity
### 4.5 Cross-world deployment relationships
### 4.6 Explicit contracts between worlds
### 4.7 Why the worlds have independent lifecycles

---
---

## Purpose

The engineering model deliberately contains three distinct **engineering worlds**:

1. **Enterprise Strata**
2. **Enterprise Portfolio**
3. **Preview Environments**

These worlds participate in the same engineering model, but they operate at different levels and therefore have different responsibilities, deployment primitives, and lifecycles.

The goal is not to invent a universal enterprise-wide definition of an environment or impose one lifecycle across the enterprise.

The goal is to establish **clear boundaries between engineering concerns while allowing the worlds to interact through explicit contracts and dependencies**.

This distinction matters because familiar terminology such as *development*, *test*, *production*, *environment*, *deployment*, *branch*, and *release* does not have the same meaning at every level.

A pragmatic enterprise engineering model cannot reasonably make every platform concern, every solution, and every Pull Request participate in one synchronized lifecycle.

Instead, each engineering world has its own lifecycle appropriate to the kind of change it governs.

```text
                         ENGINEERING MODEL
                                │
              ┌─────────────────┼─────────────────┐
              │                 │                 │
              ▼                 ▼                 ▼
           STRATA           PORTFOLIO          PREVIEW
              │                 │                 │
       platform/strata      solution-level     PR/application
          concerns            concerns          concerns
              │                 ▲                 │
              │                 │                 │
              └── dependency ───┘                 │
                                                  │
                                        workflow-managed
                                          ephemeral use
```

The worlds are therefore **related without being collapsed into one lifecycle**.

Each world is responsible for defining the meaning of its own progression, release boundaries, and deployment behavior.

A Stack, deployment, branch, configuration, or environment is therefore interpreted according to the engineering world in which it is used rather than assumed to have one universal enterprise meaning.

This allows the engineering model to use common infrastructure primitives while preserving the distinct semantics required by platform engineering, solution engineering, and application development.

---

# 1. Enterprise Strata

Enterprise Strata represents the portion of the engineering model concerned with the **strata/platform level**.

It is not the complete engineering model and is not the sole authority over enterprise engineering. Enterprise Portfolio establishes its own concerns at the solution level, and application development establishes its own concerns at the application/PR level.

Strata is one part of the model.

Its responsibility is to establish the platform-level structures, capabilities, and contracts that belong at its level.

## 1.1 Strata has an engineering-model lifecycle

Strata has a lifecycle for evolving, evaluating, validating, and releasing the engineering model itself.

This lifecycle is distinct from the operational lifecycle of the infrastructure that Strata ultimately provisions.

The distinction is important because the Strata repository does not produce a conventional runtime artifact such as an application image. The **Stack configuration itself is the release artifact for the engineering model**.

The Strata lifecycle therefore separates the continuously evolving source from the specific configuration being evaluated for acceptance.

There are three Strata Stack instances:

```text
enterprise-strata
│
├── development branch
│   │
│   └── Speculative Stack
│       │
│       └── development deployment
│
├── Prospective Stack
│   │
│   └── pinned release configuration
│       │
│       ├── Stage 1
│       ├── Stage 2
│       └── Stage 3
│
└── main branch
    │
    └── Release Stack
        │
        └── operational deployment(s)
```

These Stack instances have deliberately different semantics.

### Speculative Stack

The **Speculative Stack** is the VCS-backed development Stack.

It follows the `development` branch and has a real **development deployment** representing the continuously evolving development state of the Strata engineering model.

Its purpose is twofold:

1. provide the development deployment for the current `development` branch; and
2. provide speculative plans for proposed changes, particularly changes introduced through pull requests.

A speculative plan evaluates the proposed PR revision as a change against the current `development` branch.

Conceptually:

```text
Pull Request
     │
     ▼
PR revision
     │
     │ diff against development
     ▼
Speculative Stack
     │
     ▼
speculative plan
```

When a PR is merged, the `development` branch advances and the development deployment consumes the resulting branch configuration.

```text
enterprise-strata:development
          │
          ▼
  Speculative Stack
          │
          ▼
 development deployment
```

The development deployment is therefore a real deployment of Strata, but it is not a prospective release stage and does not represent an operational environment.

The Speculative Stack remains connected to VCS because its configuration is intentionally a moving representation of the development branch.

### Prospective Stack

The **Prospective Stack** represents the current **prospective release of the Strata engineering model**.

It is intentionally **not VCS-backed**.

A prospective release is created by pinching off a specific tagged revision from the `development` branch and uploading the corresponding Stack configuration to the Prospective Stack through the engineering-model workflow.

The uploaded configuration is a snapshot of the Strata engineering model at that release boundary.

The Prospective Stack therefore answers:

> What exact Strata engineering-model configuration are we currently progressing toward acceptance?

Its deployments represent the sequential progression of that single configuration through the engineering-model validation stages.

Conceptually:

```text
development branch
       │
       │ release tag
       ▼
engineering-model workflow
       │
       │ pinch off configuration
       ▼
Prospective Stack
       │
       ▼
      Stage 1
       │
   approval
       │
       ▼
      Stage 2
       │
   approval
       │
       ▼
      Stage 3
       │
   approval
       │
       ▼
approved prospective release
```

The stages are not separate versions of Strata. They are successive deployments of the **same pinned configuration**.

The progression is therefore:

```text
Stage 1 → Stage 2 → Stage 3
```

Each stage represents the next validation point for the same engineering-model release candidate.

If a newer release is pinched off before the previous prospective release completes its lifecycle, the newer configuration supersedes the previous candidate. The previous candidate is no longer eligible to proceed to the accepted engineering-model release.

Development itself does not need to stop while a prospective release is being validated.

```text
development
    │
    ├── change A
    ├── change B
    │
    └── release tag ──────────────┐
                                  │
                                  ▼
                           Prospective Stack
                                  │
                           Stage 1 → Stage 2 → Stage 3
                                  │
                                  │
development continues             │
    │                             │
    ├── change C                  │
    ├── change D                  │
    └── next release tag          │
                                  │
                                  ▼
                         approved prospective
```

The Prospective Stack is therefore deliberately decoupled from the moving development VCS stream.

That decoupling allows a specific engineering-model configuration to become a deployed artifact with an independent progression lifecycle while development continues.

### Release Stack

The **Release Stack** represents the operational Strata Stack.

It follows the `main` branch and is concerned with deploying the accepted Strata engineering model into its operational deployment topology.

The Release Stack therefore answers:

> What accepted Strata engineering model is being deployed operationally?

The operational deployment model is intentionally not prescribed by Strata. Depending on the operational promotion model, the Release Stack may contain one or multiple operational deployments.

Conceptually:

```text
accepted engineering-model release
              │
              ▼
          main branch
              │
              ▼
        Release Stack
              │
       ┌──────┴──────┐
       ▼             ▼
 operational      operational
 deployment       deployment
```

The Release Stack is therefore distinct from both the Speculative Stack and the Prospective Stack.

## 1.2 The two meanings of deployment

The Strata model deliberately distinguishes **engineering-model deployment** from **operational deployment**.

An engineering-model deployment establishes or evaluates a particular version of the engineering model itself.

An operational deployment applies an accepted engineering model to its intended operational environment.

These are different concerns even though both use the Stack deployment primitive.

```text
Engineering-model lifecycle

development branch
       │
       ▼
Speculative Stack
       │
       ▼
development deployment
       │
       │ release tag
       ▼
Prospective Stack
       │
       ▼
Stage 1 → Stage 2 → Stage 3
       │
       ▼
accepted engineering model


Operational lifecycle

accepted engineering model
       │
       ▼
main
       │
       ▼
Release Stack
       │
       ▼
operational deployment(s)
```

This distinction avoids treating every Stack deployment as synonymous with an environment such as development, test, or production.

The development deployment of the Speculative Stack is a real Strata development environment because Strata needs a continuously evolving development state.

The Prospective Stack deployments are **engineering-model progression stages**. They do not imply that Strata must have corresponding operational environments, nor do they establish a universal enterprise deployment lifecycle.

The operational environments are established separately by the Release Stack according to the operational deployment model.

## 1.3 Strata release identity

The Strata repository is the source of the engineering model.

A release boundary is established on the `development` branch by a tag. The tag identifies the exact source revision from which the Prospective Stack configuration is pinched off.

The resulting Stack configuration is the **engineering-model release artifact**.

```text
enterprise-strata
      │
      │ development
      ▼
release tag
      │
      │ exact source revision
      ▼
Stack configuration snapshot
      │
      ▼
Prospective Stack
      │
      ▼
Stage 1 → Stage 2 → Stage 3
```

This is different from an application release in which source code is compiled or packaged into an independently deployable artifact.

For Strata, the Stack configuration is itself the coherent artifact because the Stack definition and its locally sourced Strata implementation form one versioned engineering model.

Strata Core is therefore sourced directly by the Strata Stack rather than being treated as a collection of independently released modules.

The repository represents the source of the Strata engineering model.

The pinned Stack configuration represents the prospective release of that model.

The Stack deployments represent the application and progression of that configuration through the engineering-model lifecycle.

## 1.4 Promotion of an approved prospective release

The Prospective Stack establishes which tagged development revision is being evaluated.

Once that prospective release completes its engineering-model validation lifecycle, **only the tagged revision from which that prospective configuration was created is eligible for promotion to `main`**.

This is important because development may have continued while the prospective release was being evaluated.

For example:

```text
development

A ── B ── C ── D ── E ── F
          │
          └── strata-1.0
```

The prospective release represents commit `C`.

While it is being validated, development may continue:

```text
development

A ── B ── C ── D ── E ── F
          │
          └── strata-1.0
```

If `strata-1.0` is approved, the release workflow promotes the **commit identified by that tag**, rather than the current tip of `development`.

Conceptually:

```text
                 development
                    │
             C ── D ── E ── F
             │
             │ strata-1.0
             ▼
      Prospective Stack
             │
       S1 → S2 → S3
             │
          approved
             │
             │ promote tagged revision
             ▼
            main
             │
             ▼
        Release Stack
```

The important relationship is that the Stage 1 → Stage 2 → Stage 3 progression validates the **same tagged configuration**, while promotion to `main` advances the **original Git revision identified by that tag**.

Stage 3 does not become the source of `main`, nor does the prospective configuration become a new Git branch.

The current `development` branch therefore does not need to be frozen while a prospective release is being validated.

The three identities can legitimately differ:

```text
development HEAD
      ≠
prospective release
      ≠
main HEAD
```

The prospective release remains tied to its immutable tagged revision, while development continues independently.

Promotion therefore means **advancing the approved tagged revision into `main`**, not merging whatever happens to be current on the development branch.

Once the tagged revision becomes part of `main`, the Release Stack can consume it through its VCS relationship and perform the operational deployment lifecycle.

This establishes a clean boundary:

```text
development
    │
    │ tag
    ▼
Prospective Stack
    │
    │ Stage 1 → Stage 2 → Stage 3
    │
    │ approval
    ▼
approved tagged revision
    │
    │ promotion
    ▼
main
    │
    ▼
Release Stack
    │
    ▼
operational deployment(s)
```

## 1.5 Strata Stack registration

The Strata Stack instances are established as part of the engineering-model bootstrap rather than by the `enterprise-strata` repository itself.

The `.github` repository provides the bootstrap/control-plane configuration responsible for registering the three Stack instances and placing them within the HCP Terraform project.

Conceptually:

```text
amiasea/.github
       │
       │ Stack registration
       ▼
HCP Terraform
amiasea project
       │
       ├── strata-speculative
       ├── strata-prospective
       └── strata-release
```

The three Stack instances have different source relationships:

```text
strata-speculative
    → enterprise-strata:development

strata-prospective
    → no VCS connection

strata-release
    → enterprise-strata:main
```

The Prospective Stack receives configurations through the engineering-model workflow rather than through a VCS trigger.

The registration establishes **which Stack instances exist, their roles, their project scope, and their source mechanism**. It does not contain the substantive Strata implementation.

The `enterprise-strata` repository remains the source of the engineering model:

```text
amiasea/.github
      │
      │ establishes Stack topology
      ▼
HCP Terraform
amiasea project
      │
      ├── strata-speculative
      ├── strata-prospective
      └── strata-release

amiasea/enterprise-strata
      │
      ├── Stack configuration
      ├── Strata implementation
      └── modules/
```

This creates a clean separation between **bootstrap**, **Stack topology**, **engineering-model release**, and **operational deployment**.

## 1.6 Why this model fits Strata

Strata is treated as a coherent engineering model rather than as a collection of independently released modules.

The model preserves a single source repository while allowing that source to have different lifecycle semantics at different points in its progression.

```text
                    enterprise-strata
                           │
                     development
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
      Speculative Stack          release tag
              │                         │
              ▼                         ▼
 development deployment        Prospective Stack
              │                         │
        PR speculative          S1 → S2 → S3
            plans                      │
              │                        ▼
              │                    approved
              │                        │
              │                        ▼
              │                      main
              │                        │
              │                        ▼
              │                 Release Stack
              │                        │
              │                        ▼
              │              operational deployment(s)
              │
              └── development continues independently
```

The three Stack instances therefore do not represent three copies of the same environment lifecycle.

They represent three distinct roles:

| Stack                 | Source                        | Role                                                                                          |
| --------------------- | ----------------------------- | --------------------------------------------------------------------------------------------- |
| **Speculative Stack** | `development` branch          | Maintain the development state and evaluate proposed engineering-model changes                |
| **Prospective Stack** | Pinned uploaded configuration | Progress the current engineering-model release candidate through sequential validation stages |
| **Release Stack**     | `main` branch                 | Deploy the accepted engineering model operationally                                           |

The **Speculative Stack** is connected to VCS because it represents the moving development source and provides the basis for PR speculative plans.

The **Prospective Stack** is deliberately disconnected from VCS because it represents a pinned engineering-model artifact progressing through an approval lifecycle.

The **Release Stack** is connected to `main` because `main` represents the accepted engineering model from which operational deployment proceeds.

This gives Strata a clean progression:

```text
development source
    │
    ├── PR
    │    │
    │    ▼
    │  speculative plan
    │
    └── merge to development
         │
         ▼
    development deployment
         │
         │ tag
         ▼
    pinned engineering-model artifact
         │
         ▼
    Prospective Stack
         │
         ▼
    Stage 1 → Stage 2 → Stage 3
         │
         ▼
    approved tagged revision
         │
         ▼
    main
         │
         ▼
    Release Stack
         │
         ▼
    operational deployment(s)
```

The repository therefore remains the source of truth for the engineering model, while the Prospective Stack provides the necessary separation between a **moving development stream** and a **stationary release candidate**.

This separation is fundamental to the Strata model. It allows development to continue independently while a specific engineering-model configuration progresses through validation, without confusing engineering-model deployment with operational deployment.

---
