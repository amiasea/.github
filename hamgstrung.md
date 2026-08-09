# Hamstrung

A running tally of things that are currently hampering the engineering model.

The purpose of this document is to capture places where the intended design is constrained by:

- platform limitations
- missing integrations
- immature product capabilities
- undocumented behavior
- tooling gaps
- architectural mismatches between desired operating models and available primitives

These are not necessarily design failures. Some limitations may disappear as platforms evolve.

The goal is to preserve the reasoning behind architectural decisions and identify areas that can be revisited when capabilities change.

---

# Azure Entra ID Federated Identity Claims Matching

## Problem

HCP Terraform OIDC federation requires matching the token subject claim in Azure Entra ID.

The intended design was to create least-privilege federated identities based on Terraform execution context while avoiding unnecessary duplication.

Example desired subject pattern:

```text
organization:amiasea:project:amiasea:workspace:engineering_foundation:run_phase:*

The intent was to allow a single identity rule to represent a class of Terraform execution phases.

Current Limitation

Azure Entra ID federated identity claim matching does not behave as a general wildcard or pattern matching system.

Expressions that logically represent a valid pattern are rejected or do not match the presented OIDC subject.

The expected behavior:

run_phase:*

matching:

run_phase:plan
run_phase:apply

does not work as expected.

Impact

The identity model must become more explicit.

Instead of one federated identity representing a category of Terraform actions, separate identity definitions may be required.

Example:

run_phase:plan

run_phase:apply
Desired Capability

Support predictable claim matching semantics:

documented wildcard behavior
supported glob matching
supported regular expressions
easier management of Terraform OIDC subject patterns
Status

Open

Terraform Stacks: Ephemeral Root-Level Module Outputs
Problem

The Enterprise Portfolio model requires understanding of how ephemeral deployments compose with reusable infrastructure definitions.

A preview deployment may need to dynamically create and destroy complete solution instances while still consuming outputs from upstream modules.

The desired behavior:

Preview Deployment

PR-123
   |
   +-- ephemeral application
   |
   +-- ephemeral dependencies
   |
   +-- root outputs available for composition
Current Limitation

Terraform Stack deployment composition is designed around declared Stack components and their versioned module relationships.

Ephemeral root-level module output behavior does not map cleanly to the desired preview lifecycle model.

The Stack model does not currently provide an obvious mechanism where temporary deployments can freely appear and disappear while behaving as first-class upstream dependencies.

Impact

Preview environments may require a different lifecycle model than long-lived validation or operational deployments.

The architectural question becomes:

Should preview deployments:

exist as Stack deployments with special lifecycle behavior?

or

exist through a separate ephemeral orchestration model?
Desired Capability

Support first-class ephemeral deployments:

PR-scoped lifecycle
dynamic creation and destruction
dependency graph participation
temporary upstream/downstream relationships
preview environment metadata
Status

Open

HCP Waypoint Integration with Terraform Stacks
Problem

Waypoint provides an attractive developer-facing application provisioning experience.

The desired Enterprise Portfolio workflow could benefit from a catalog-style interface:

Application:
    Orders API

Solution:
    Enterprise Portfolio v2

Environment:
    Validation

Deploy
Current Limitation

Waypoint currently integrates with HCP Terraform through no-code modules and workspaces.

The model is:

Waypoint

    |
    v

HCP Terraform Workspace

    |
    v

Terraform Module

not:

Waypoint

    |
    v

Terraform Stack Deployment
Impact

Waypoint cannot currently serve as the native user interface for Enterprise Portfolio Stack instantiation.

A custom platform layer would still be required to provide a Stack-oriented experience.

Desired Capability

Support:

Waypoint

    |
    v

Terraform Stack

    |
    v

Stack Deployment

including:

Stack-aware templates
Stack deployment selection
Stack outputs
Stack lifecycle management
Status

Open

Sentinel Policy Integration with Terraform Stacks
Problem

Enterprise Portfolio deployments require admission controls.

Examples:

approved OAR versions
approved TDP versions
image promotion rules
identity constraints
environment policies

The desired flow:

Stack Deployment

    |
    v

Policy Evaluation

    |
    v

Approval

    |
    v

Apply
Current Limitation

HCP Terraform Sentinel policy enforcement is documented around workspaces.

The current policy model does not provide an equivalent documented Stack-native policy attachment mechanism.

Impact

Policy enforcement may need to exist outside the Stack execution boundary.

Possible alternatives:

Enterprise Portfolio Controller

    |
    +-- Policy evaluation
    |
    +-- Stack deployment request

or:

Release Workflow

    |
    +-- Validation
    |
    +-- Stack deployment
Desired Capability

Native Stack governance:

Stack policy sets
Stack-aware plan evaluation
Stack deployment admission control
Stack-native policy reporting
Status

Open

---

# Terraform Stacks: Deployment Notification Events

## Problem

The Enterprise Portfolio model requires external systems to understand deployment lifecycle events.

Examples:

- deployment started
- deployment waiting for approval
- deployment completed
- deployment failed
- deployment promoted
- deployment state changed

These events are required for integration with:

- GitHub deployment status
- release management systems
- enterprise dashboards
- operational workflows
- audit systems

The desired behavior:

```text
Terraform Stack Deployment

        |
        v

Deployment Event

        |
        +-- GitHub status update
        +-- Release tracking
        +-- Audit record
        +-- External automation
Current Limitation

HCP Terraform notification integrations are primarily workspace-oriented.

The existing notification model provides events such as:

run:created

run:planning

run:needs_attention

run:applying

run:completed

run:errored

but these are associated with workspace runs.

Terraform Stacks do not currently expose an equivalent documented deployment event stream for external systems.

Impact

Stack deployments cannot easily participate as a first-class deployment source for external orchestration systems.

The platform must either:

poll Stack deployment state
wrap Stack operations with an external controller
maintain a separate deployment tracking system

Example:

Enterprise Portfolio Controller

        |
        +-- trigger Stack deployment
        |
        +-- monitor Stack state
        |
        +-- publish deployment events
Desired Capability

Native Stack deployment events:

deployment created
deployment started
deployment waiting for approval
deployment completed
deployment failed
deployment promoted

with integration support for:

webhooks
event streams
GitHub Deployments API
enterprise release systems
Status

Open

---

# Terraform Stacks: Pull Request Preview Deployment Lifecycle

## Problem

The Enterprise Portfolio model requires support for preview environments that are created from pull requests and exist only for the duration of evaluating proposed changes.

The desired workflow:

```text
Pull Request

    |
    v

Preview Environment Created

    |
    v

Change Evaluated

    |
    v

Pull Request Merged or Closed

    |
    v

Preview Environment Destroyed

Preview environments have different lifecycle characteristics than validation or operational environments:

they are ephemeral
they are tied to source changes
they may exist concurrently
they are created and destroyed dynamically
they do not represent a promoted release artifact
Current Limitation

Terraform VCS integration and speculative plans provide visibility into pull request changes, but a speculative plan is not a deployment lifecycle.

A speculative plan answers:

"What would Terraform change if this configuration were applied?"

It does not answer:

"Create and manage an ephemeral environment representing this pull request."

The Terraform Stack model is primarily oriented around declared deployments and their managed lifecycle.

A preview environment requires additional concepts:

PR identity
environment naming
environment creation
lifecycle ownership
cleanup triggers
dependency handling
expiration behavior

These are not inherently Terraform concepts.

Why HashiCorp Cannot Provide a Universal Preview Model

A definitive Terraform-native preview deployment model would require assumptions about what constitutes a preview trigger.

Different organizations may define preview lifecycle differently.

Examples:

Pull Request opened
        |
        v
Create preview

or:

Feature branch pushed
        |
        v
Create preview

or:

Manual request
        |
        v
Create preview

or:

Application release candidate created
        |
        v
Create preview

Terraform cannot universally determine:

what event creates a preview
who owns the lifecycle
when it should be destroyed
whether multiple previews are allowed
what dependencies should be ephemeral
whether the environment should be promoted or discarded

The trigger semantics belong to the engineering workflow model.

Potential Future Capability

Terraform could support preview workflows through explicit configuration rather than assuming a lifecycle.

For example:

preview_environment {
  trigger = "pull_request"

  name_template = "preview-${pull_request.number}"

  destroy_trigger = "pull_request.closed"

  ttl = "72h"
}

This would allow organizations to define their own preview semantics while Terraform provides the execution lifecycle.

Impact

Preview environments require additional orchestration outside of standard Terraform Stack deployment behavior.

Possible implementation:

GitHub Pull Request

        |
        v

Preview Controller

        |
        +-- creates Stack deployment
        +-- assigns preview identity
        +-- tracks PR association
        +-- destroys deployment
             when lifecycle ends

        |
        v

Terraform Stack

The preview controller becomes responsible for lifecycle coordination while Terraform remains responsible for infrastructure realization.

Design Consideration

Preview deployments should not necessarily share the same lifecycle model as validation or operational deployments.

Validation:

long-lived
versioned
promotional
controlled

Operational:

long-lived
enterprise-managed
production-oriented

Preview:

ephemeral
source-change-driven
temporary
disposable

The difference is not merely environment naming. It is a fundamentally different lifecycle.

Status

Open