# Work Streams

A work stream is a distinct body of engineering work within the engineering model.

Work streams describe what is being engineered, not the repositories, Terraform workspaces, subscriptions, projects, workflows, APIs, or other mechanisms through which that work is realized.

The current delivery model has three primary work streams:

* Institutive
* Strata
* Kitting

## Institutive

Institutive is the work stream through which the delivery model itself is defined and established.

Institutive establishes the machinery through which engineering work can be developed, promoted, and operated.

This includes work such as:

* delivery and promotion structures;
* repositories and control-plane organization;
* Terraform and TFE mechanisms;
* GitHub workflows;
* API orchestration;
* webhook integration; and
* other machinery required to operate the delivery model.

Institutive is therefore concerned with establishing the machinery of delivery rather than delivering a particular hosted solution.

The Amiasea API is an example of Institutive work. Its orchestration of Strata promotion does not make the API itself Strata work.

## Strata

Strata is the work stream through which the hosting model is established.

Strata establishes:

* Hosting;
* Collective services;
* logical hosting domains;
* cluster boundaries;
* cloud services required by the hosting model; and
* other infrastructure required to host applications.

Strata itself is promoted through the delivery machinery established by Institutive.

The workflows and API mechanisms used to promote Strata work do not therefore constitute Strata work merely because they are implemented in or alongside the Strata repository.

Strata has jurisdiction over the hosting boundaries it establishes, including the logical domains within its Hosting and Collective scopes.

Strata Speculative and Prospective may use production-grade Kitting releases as representative workloads for testing the hosting model.

That use does not make Kitting part of Strata's promotional lifecycle.

## Kitting

Kitting is the work stream through which applications and other domain workloads are delivered into the hosting model established by Strata.

Kitting consumes Strata capabilities rather than defining the hosting model itself.

Kitting has its own delivery and promotion lifecycle.

Its promotional stages are therefore not synchronized with the corresponding Strata stages merely because both use the terms Speculative, Prospective, and Operative.

For example, Kitting may be developing a new application release while Strata remains unchanged for an extended period. Conversely, Strata may change its hosting model while Kitting continues to operate from an established production-grade release.

Kitting may therefore be used as a validation workload by Strata without its own delivery work being promoted through Strata.

```text
Strata
    │
    ├── establishes hosting model
    │
    └── validates against
            │
            └── established Kitting release

Kitting
    │
    └── independently promotes application work
```

## Work Stream Boundaries

Work-stream boundaries are semantic boundaries.

They do not require corresponding infrastructure boundaries.

A repository may contain mechanisms used by more than one work stream. A Terraform workspace may establish infrastructure used by another work stream. A TFE project, GitHub repository, subscription, or API endpoint does not therefore define the semantic boundary of a work stream.

The same delivery machinery may promote different work streams.

Conceptually:

```text
Institutive
    │
    └── establishes delivery machinery
              │
              ├── promotes Strata
              │
              └── promotes Kitting
```

The machinery used to promote a work stream does not become part of the work being promoted.

> **A work stream defines the work; its delivery mechanisms define how that work is established and promoted.**
