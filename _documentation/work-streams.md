# Work Streams

A work stream is a distinct body of engineering work within the Amiasea engineering model.

Work streams describe **what is being engineered**, not the repositories, Terraform configurations, Terraform workspaces, subscriptions, projects, workflows, APIs, or other mechanisms through which that work is realized.

The current delivery model has three primary work streams:

* Institutive
* Strata
* Kitting

These work streams are semantic boundaries. They may use the same implementation mechanisms while performing conceptually different work.

## Institutive

Institutive is the work stream through which the Amiasea delivery model itself is established.

Institutive establishes the machinery through which engineering work can be developed, promoted, and operated.

This includes work such as:

* delivery and promotion structures;
* repositories and control-plane organization;
* Terraform and HCP Terraform mechanisms;
* GitHub workflows and integrations;
* the Amiasea API and UI;
* API orchestration;
* webhook integration;
* identity and authorization mechanisms; and
* other machinery required to operate the engineering delivery model.

Institutive is therefore concerned with establishing the **delivery model**, rather than delivering a particular hosted application solution.

The Amiasea API is an example of Institutive work. Its orchestration of Strata and Kitting promotion does not make the API itself Strata or Kitting work.

Institutive is not a stage of Strata. The fact that Institutive work may establish infrastructure used by Strata does not make that work part of Strata.

## Strata

Strata is the work stream through which the hosting model is established.

Strata does not itself host application solutions. It establishes the infrastructure, boundaries, and promotion model through which hosting can be provided to application solutions.

Strata establishes concepts such as:

* Hosting;
* Collective services;
* logical hosting domains;
* cluster boundaries;
* cloud services required by the hosting model; and
* other infrastructure required to establish hosting capacity.

Strata's promotion model provides a controlled progression through which changes to the hosting model can be established and validated.

Strata may use representative application workloads to validate its hosting model. A Kitting release may therefore be deployed into a Strata promotional environment for validation without that Kitting work becoming part of Strata.

Strata has jurisdiction over the hosting boundaries it establishes, including the logical domains within its Hosting and Collective scopes.

Strata promotion is independent of the promotion lifecycle of the application solutions that consume Strata capabilities.

For example, Strata may remain unchanged while application solutions are independently released into its established hosting model. Conversely, Strata may change its hosting model while an application solution continues to operate from an established release.

## Kitting

Kitting is the work stream through which application solutions and other domain workloads are delivered into the hosting model established by Strata.

Kitting consumes Strata capabilities rather than defining the hosting model itself.

Kitting has its own delivery and promotion lifecycle.

Its promotional stages are therefore not synchronized with Strata's promotional stages merely because both may use terms such as Speculative, Prospective, and Operative.

Kitting may use different realization mechanisms depending on the hosting model. Terraform, Kubernetes, Ansible, or other mechanisms may participate in Kitting without changing the semantic identity of the work as Kitting.

For example, Terraform may establish infrastructure required by an application solution, while Ansible may subsequently realize application configuration within a Kubernetes cluster. Both mechanisms can therefore participate in the same Kitting work.

Kitting may also be used as a representative workload by Strata for validation. That does not cause Kitting to become part of Strata's promotional lifecycle.

## Delivery

Delivery is the implementation structure through which the Amiasea engineering model is established and its work streams are realized.

Delivery is not itself a work stream. It is the machinery through which work streams are established, promoted, and operated.

The delivery implementation may contain mechanisms for multiple work streams:

```text
delivery/
├── _bootstrap/
├── institutive/
├── strata/
└── kitting/
```

The organization of these directories reflects the conceptual responsibility of the work being implemented, rather than the implementation technology used.

For example, Terraform may be used in all three work streams while performing fundamentally different work:

```text
Institutive
    │
    └── Terraform establishes the delivery model

Strata
    │
    └── Terraform establishes and promotes the hosting model

Kitting
    │
    └── Terraform realizes application solution infrastructure
```

The use of Terraform does not therefore make these activities one work stream.

Likewise, GitHub, HCP Terraform, Kubernetes, Ansible, Azure services, and the Amiasea application may participate in multiple aspects of delivery without defining the semantic boundaries of those work streams.

## Work Stream Boundaries

Work-stream boundaries are semantic boundaries.

They do not require corresponding infrastructure boundaries.

A repository may contain mechanisms used by more than one work stream. A Terraform configuration may establish infrastructure used by another work stream. A Terraform workspace, HCP Terraform project, GitHub repository, Azure subscription, resource group, API endpoint, or Kubernetes cluster does not therefore define the semantic boundary of a work stream.

The same implementation mechanism may realize different work streams.

Conceptually:

```text
                         Amiasea
                Engineering Delivery Model
                           │
                           ▼
                        Delivery
                           │
             ┌─────────────┼─────────────┐
             │             │             │
        Institutive      Strata        Kitting
             │             │             │
       establishes     establishes     delivers
       the delivery    the hosting     application
       model           model           solutions
```

The delivery machinery may use many technologies:

```text
GitHub
   │
HCP Terraform
   │
Terraform
   │
Kubernetes
   │
Ansible
   │
Azure
   │
Amiasea API / UI
```

These technologies are mechanisms within the engineering model. None of them independently defines a work stream.

The purpose of Amiasea is to provide a coherent engineering-delivery model across these mechanisms—something that the release-management capabilities of any individual mechanism, including GitHub, do not provide by themselves.

> **A work stream defines the work; delivery defines the machinery through which that work is established and promoted.**

> **Implementation mechanisms do not define architectural boundaries. The same mechanism may participate in multiple work streams while performing conceptually different work.**
