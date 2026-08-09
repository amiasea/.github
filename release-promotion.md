Release Classification and Enterprise Portfolio Deployment Model
Overview

This model separates release classification, promotion mechanics, deployment lifecycle behavior, and environment realization.

A release artifact is not directly tied to a deployment environment. Instead, an artifact is assigned a release classification that determines the lifecycle behavior, promotion model, and enterprise portfolio deployment domain it is eligible to enter.

The goal is to avoid coupling:

source control workflows
artifact creation
release governance
infrastructure deployment
environment lifecycle management

Terraform Stacks provide deployment primitives, but they do not define the engineering model. The engineering model establishes lifecycle rules, promotion semantics, and operational expectations on top of those primitives.

Core Concepts
Release Artifact

A release artifact is an immutable deployable object.

Examples:

container image
package
application bundle
deployment artifact

The artifact does not know its destination environment.

The artifact contains release classification metadata:

release_class: validation
version: 1.4.0

The artifact says:

"I am a validation release."

It does not say:

"Deploy me to production."

Release Classification

Release classification defines the lifecycle category of an artifact.

Current classifications:

Release Class	Purpose
Preview	Can we prove this change works?
Validation	Can engineers validate this continuously?
Operational	Can the enterprise operate this safely?

Release classes are not only metadata categories. Each release class has different lifecycle expectations and promotion mechanics.

Preview Release Class
Purpose

Question answered:

Can we prove this change works?

Preview releases are intended for rapid feedback, experimentation, and demonstration.

Preview has different lifecycle characteristics from validation and operational releases.

Deployment domain:

enterprise-portfolio-release-class-preview

Preview deployments:

are expected to be numerous
are independent of each other
are ephemeral
have destruction as a normal lifecycle event

Example lifecycle:

create
  |
  v
preview deployment
  |
  v
evaluate
  |
  v
destroy

Preview deployments do not promote between environments.

A preview Stack exists to support rapid creation and cleanup of solution instances.

Preview is not a lower-quality version of validation. It is a different lifecycle model.

Validation Release Class
Purpose

Question answered:

Can engineers validate this continuously?

Validation releases represent artifacts that have passed initial checks and are ready for structured engineering validation.

Deployment domain:

enterprise-portfolio-release-class-validation

    valid-lvl-1
          |
          v
    valid-lvl-2

Validation uses internal deployment promotion.

Promotion means:

"The same approved solution composition has successfully progressed through increasingly representative validation environments."

Example:

app:v1.4.0

PMR modules:
  hosting:v3
  policy:v2


valid-lvl-1
      |
      v
valid-lvl-2

The promoted solution composition remains the same.

The artifact does not change during validation promotion.

The environments may differ by:

configuration
validation policies
scale
test requirements
approval requirements
access boundaries

The purpose of validation promotion is confidence accumulation.

Operational Release Class
Purpose

Question answered:

Can the enterprise operate this safely?

Operational releases represent artifacts approved for enterprise operation.

Deployment domain:

enterprise-portfolio-release-class-operational

    operational deployment

Operational intentionally differs from validation.

The operational Stack establishes one enterprise operational deployment boundary.

Example:

enterprise-portfolio-release-class-operational

    operational environment

Promotion inside the operational boundary is not necessarily Terraform shape promotion.

Instead, a capable hosting platform may manage:

configuration promotion
traffic segmentation
feature rollout
revision promotion
progressive delivery

Example:

operational deployment

        |
        +-- alpha configuration
        |
        +-- beta configuration
        |
        +-- production configuration

The operational model assumes the hosting platform has sufficient capabilities to safely manage release progression.

If a hosting platform cannot provide these capabilities, additional deployment mechanics may be required. This is a hosting platform capability concern, not a requirement that changes the enterprise model.

GitHub Release Classification Environments

GitHub Environments represent release workflow controls, not enterprise deployment environments.

Recommended naming:

release-class-preview

release-class-validation

release-class-operational

Their purpose:

"Can this workflow produce or promote this release classification?"

They do not represent:

Azure environments
Terraform Stack deployments
enterprise lifecycle stages
hosting boundaries

Example:

GitHub Workflow

tag created
    |
    v
release workflow
    |
    v
release-class-validation
    |
    v
validation artifact published

The workflow produces a classified artifact.

The enterprise portfolio deployment lifecycle begins after classification.

Enterprise Portfolio Deployments

Enterprise Portfolio deployments manage solution instantiation and lifecycle behavior.

They own:

deployment shape
environment configuration
infrastructure dependencies
identity boundaries
policies
approvals

Each release class has its own lifecycle contract.

Example:

enterprise-portfolio-release-class-preview

    ephemeral deployments


enterprise-portfolio-release-class-validation

    valid-lvl-1
          |
          v
    valid-lvl-2


enterprise-portfolio-release-class-operational

    operational deployment

The Stack is not only an infrastructure container. It represents a deployment lifecycle model.

Promotion Model

Promotion is separate from artifact creation.

The lifecycle:

Developer Workflow
        |
        v
Source Change
        |
        v
Release Tag
        |
        v
Release Artifact
        |
        v
Release Classification
        |
        v
Enterprise Portfolio Lifecycle
        |
        v
Deployment Realization

A tag does not mean production.

A tag means:

"Release management has identified this source state as a candidate release."

Promotion determines how that release progresses based on its release class.

Artifact Shape vs Deployment Shape

A key distinction:

Release Artifact Shape

The artifact itself remains immutable.

Example:

app:v1.4.0

remains:

app:v1.4.0

during promotion.

Deployment Shape

Deployment shape belongs to the enterprise portfolio lifecycle.

Examples:

Validation:

validation environments
engineering access
diagnostic capabilities
controlled testing

Operational:

enterprise configuration
customer exposure
production policies
operational requirements

The environment changes because operating requirements change, not because the artifact changes.

Terraform Stack Role

Terraform Stack deployments provide infrastructure deployment primitives.

They manage:

infrastructure state
hosting product configuration
resource dependencies
environment shape
solution references

They do not define universal release promotion semantics.

The engineering model defines how each Stack behaves.

Solution References

Enterprise Portfolio identity is based on versioned solution references, not artifact build history.

A deployment references:

versioned images
PMR modules
configuration definitions
policy definitions

Example:

solution release:

image:
  app:v1.4.0

modules:
  hosting:v3
  policy:v2

A later solution release may reference:

solution release:

image:
  app:v1.5.0

modules:
  hosting:v3
  policy:v2

This does not represent Terraform promotion.

It represents a new solution composition.

Identity and Enforcement

The engineering model defines desired rules. Enforcement may occur through:

identity boundaries
OIDC federation
policy validation
artifact access controls
deployment approvals

Example:

A Terraform deployment identity may only retrieve artifacts allowed for its lifecycle boundary.

validation deployment identity

    allowed:
      validation-approved images


operational deployment identity

    allowed:
      operational-approved images

Least privilege is enforced through identity wherever possible.

GitHub Environment vs Enterprise Portfolio Deployment

These concepts are intentionally different.

Concept	Purpose
GitHub Environment	Release workflow control
Release Class	Artifact lifecycle category
Enterprise Portfolio Deployment	Solution lifecycle behavior
Terraform Stack	Infrastructure realization
Design Principles

A release artifact should not know where it will run.

A deployment lifecycle should define how promotion works.

A Terraform Stack should not be assumed to represent a universal promotion model.

Different release classes may require different lifecycle mechanics.

Preview, validation, and operational releases intentionally have different behaviors:

Release Class	Deployment Behavior	Promotion Model
Preview	Many ephemeral deployments	No promotion; create and destroy
Validation	Persistent validation deployments	Linear deployment promotion
Operational	Single operational deployment boundary	Configuration-based progressive promotion

The separation enables:

independent release governance
flexible deployment mechanics
least-privilege identity boundaries
environment evolution without changing application workflows
enterprise-controlled promotion paths
hosting-platform-specific delivery strategies
explicit lifecycle contracts rather than accidental conventions