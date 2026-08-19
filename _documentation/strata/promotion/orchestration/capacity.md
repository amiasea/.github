# Strata Speculative Capacity

The Speculative Capacity System provides the bounded hosting capacity through which Strata Speculative candidates may be realized.

It is delivery machinery supporting the Speculative stage. It is not a promotional stage, hosting resource, or application deployment system.

> **Speculative promotion consumes capacity; the capacity system determines when that capacity is available.**

# Capacity Domain

Strata Speculative is established within the `amiasea-speculative` subscription boundary.

Capacity consists of paired Hosting and Collective environments:

```text
Speculative
├── Slot 1
│   ├── Hosting
│   └── Collective
├── Slot 2
│   ├── Hosting
│   └── Collective
└── ...
```

Each slot is an independently assignable Speculative environment.

Hosting and Collective remain distinct capacity domains, but their environments are paired within each slot and assigned together.

The number of slots is declared capacity. It is not part of Speculative's promotional semantics.

# Capacity Establishment

The initial capacity is established by the Institutive delivery machinery.

The current Terraform boundary is:

```text
amiasea/.github
└── terraform/
    └── delivery/
        └── strata/
            └── speculative/
```

That configuration establishes the `amiasea-speculative` subscription and its Hosting and Collective environment boundaries.

The initial physical realization is Azure resource groups:

```text
amiasea-speculative
├── hosting-1
├── collective-1
├── hosting-2
├── collective-2
└── ...
```

Resource groups with the same ordinal form a capacity pair:

```text
hosting-1    ↔    collective-1
hosting-2    ↔    collective-2
hosting-3    ↔    collective-3
```

Each pair uses the same configured size. Hosting and Collective are therefore not independently sized within a slot.

The resource groups are the current provider realization of capacity. They are not the capacity abstraction itself.

For example:

```text
speculative_capacity = 2
```

establishes:

```text
hosting-1    ↔    collective-1
hosting-2    ↔    collective-2
```

Changing declared capacity is initially an infrastructure-management operation rather than a runtime SCM operation.

A separate capacity workspace may be introduced later if capacity establishes an independently governed infrastructure lifecycle. It is not required by the capacity model.

# Capacity Contract

Capacity exposes an intentionally opaque contract to promotion.

A consumer requests an environment and receives an availability outcome.

A successful assignment provides both the Hosting and Collective environments belonging to the same capacity slot.

The consumer does not need to know:

* how many slots exist;
* how declared capacity is configured;
* whether capacity is pre-provisioned;
* whether additional capacity is being established;
* how an environment is prepared;
* how an environment is reset;
* which Terraform configuration establishes it; or
* which provider resources realize it.

The observable contract is:

```text
request
    ↓
pending
    ↓
capacity available
    ↓
paired environment assignment
```

A request may remain pending when capacity cannot yet be satisfied.

> **Capacity availability is observable; capacity mechanics are opaque.**

# Capacity Units

The fundamental capacity unit is an independently assignable environment pair.

```text
capacity unit
├── Hosting environment
└── Collective environment
```

The initial provider realization is a pair of Azure resource groups, but the capacity contract does not depend on that implementation.

```text
capacity unit
    ↓
Strata environment pair
    ↓
provider realization
```

The capacity model therefore does not require the SCM to understand Azure resource groups or other provider-specific resources.

The initial implementation is Azure-specific. The logical capacity contract is not.

# Environment Types

Capacity is separated according to Hosting and Collective responsibility.

```text
Hosting capacity
Collective capacity
```

The two domains are not interchangeable.

A Hosting environment is paired with the corresponding Collective environment. A capacity shortage does not authorize independently assigning an environment from another pair.

The underlying provider resources may be similar while their semantic responsibilities remain distinct.

# Declared Capacity

Capacity is declared as a number of paired environments.

For example:

```text
speculative_capacity = 2
```

defines:

```text
Slot 1
├── Hosting
└── Collective

Slot 2
├── Hosting
└── Collective
```

Each member of a pair receives the same configured size.

These values define the physical capacity established for the Speculative platform. They are implementation configuration, not promotional semantics.

The SCM governs utilization of the established capacity. It does not need to own the declared capacity value.

Capacity may therefore be changed independently of candidate assignment:

```text
code change
    ↓
Terraform execution
    ↓
paired physical capacity
    ↓
SCM
```

# Capacity Availability

Infrastructure existence does not by itself establish capacity availability.

```text
resource-group pair exists
    ≠
environment pair available
```

Both environments may require initialization, cleanup, validation, or other preparation before the pair can safely receive a candidate.

Availability therefore represents a delivery-system condition:

```text
infrastructure
    ↓
preparation
    ↓
available capacity
```

Only a complete pair that is safe for assignment may be reported as available.

# Capacity Growth

The initial capacity model does not require runtime capacity growth.

Declared capacity can be increased through a reviewed Terraform configuration change:

```text
capacity configuration
    ↓
Terraform
    ↓
additional Hosting + Collective pair
    ↓
available capacity
```

The capacity architecture does not preclude future runtime capacity management.

If capacity later becomes dynamically expandable, that mechanism may operate behind the same logical capacity contract.

> **Capacity growth is an implementation capability, not a requirement of the promotion request protocol.**

# Speculative Capacity Manager

The Speculative Capacity Manager is the API role responsible for orchestrating the use of Speculative capacity.

The SCM does not own the underlying infrastructure merely because it governs its utilization.

Its responsibility is to coordinate logical capacity:

```text
candidate
    ↓
capacity request
    ↓
SCM
    ↓
available pair
    ↓
assignment
```

The SCM may govern:

* capacity requests;
* availability;
* reservation;
* environment assignment;
* occupancy;
* release; and
* transitions required to return capacity to service.

The SCM should not need to know:

* how Azure resource groups are created;
* which Terraform configuration establishes them;
* which HCP Terraform workspace performs the infrastructure operation;
* how provider authentication works; or
* how an environment is physically reset.

> **The SCM governs capacity utilization; Institutive establishes the capacity machinery.**

# Availability and Assignment

An available environment pair becomes associated with a candidate through assignment.

The capacity system must preserve the invariant that one pair cannot be simultaneously assigned to competing candidates.

Conceptually:

```text
available
    ↓
assigned
    ↓
occupied
    ↓
released
    ↓
prepared
    ↓
available
```

Assignment includes both sides of the pair:

```text
candidate
    ↓
Slot 2
├── hosting_environment_id
└── collective_environment_id
```

The two environments therefore have the same assignment lifecycle.

Assignment is delivery state. It is not Terraform state and does not require a corresponding provider resource.

# Capacity Lifecycle

Capacity and candidate lifecycles are related but independent.

A capacity pair may exist before a candidate requests it:

```text
capacity
    ↓
available
    ↓
candidate assignment
```

A candidate may also exist before capacity is available:

```text
candidate
    ↓
capacity request
    ↓
pending
```

Releasing a candidate does not necessarily destroy the underlying environment pair.

Capacity may be retained, reset, replaced, or otherwise prepared for subsequent use.

# Environment Reset

An environment pair must return to a known safe state before becoming available to another candidate.

The capacity contract does not prescribe the reset mechanism.

A pair may be:

* destroyed and recreated;
* reset in place;
* reconciled through Terraform;
* replaced; or
* prepared through another controlled mechanism.

The invariant is:

```text
candidate released
    ↓
Hosting + Collective made safe
    ↓
environment pair available
```

`terraform destroy` is therefore an implementation option, not a capacity semantic.

# Capacity Events

Capacity participates in the event-driven delivery architecture.

Logical events may include:

```text
capacity_requested
capacity_available
capacity_assigned
capacity_released
capacity_unavailable
```

These events describe changes relevant to capacity orchestration.

They do not require the consumer to poll for availability.

The broader event vocabulary is defined in `events.md`.

# Infrastructure Boundary

Terraform establishes the physical infrastructure through which Speculative capacity is realized.

Conceptually:

```text
Institutive delivery machinery
        ↓
Strata Speculative configuration
        ↓
amiasea-speculative
        ↓
Hosting / Collective environment pairs
        ↓
logical capacity
        ↓
Speculative Capacity Manager
```

Terraform establishes the durable infrastructure and its declared baseline shape.

The SCM operates the resulting capacity from the perspective of allocation and utilization.

The two responsibilities are intentionally separate.

# Capacity Scaling

Capacity scaling changes the number of assignable Strata Speculative environments.

```text
Capacity scaling
    → number of Hosting + Collective pairs

Kubernetes scaling
    → runtime resources

Application scaling
    → application instances
```

The Speculative Capacity System concerns the first of these.

It does not govern Kubernetes pods, nodes, or application replicas within an environment.

Initially, capacity scaling is performed by changing declared capacity through the Institutive Terraform configuration.

# Boundary

The Speculative Capacity System is responsible for the capacity abstraction consumed by Speculative promotion.

The Speculative Capacity Manager is responsible for orchestrating the use of that capacity through the Amiasea API.

Institutive delivery machinery is responsible for establishing the initial physical capacity available to the system.

The capacity system does not define:

* the semantic meaning of Speculative;
* promotional eligibility;
* GitHub governance;
* candidate identity;
* workflow implementation;
* application delivery;
* Kubernetes scaling; or
* provider-specific infrastructure mechanics.

The capacity system establishes one fundamental contract:

> **Speculative consumers request bounded capacity and receive a paired Hosting and Collective environment when the capacity system can satisfy that request.**

How that capacity is physically established, expanded, prepared, assigned, released, and replaced remains behind the capacity boundary.
