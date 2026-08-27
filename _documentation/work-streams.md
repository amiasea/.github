**Work Streams**

A work stream is a distinct body of engineering work within the Amiasea engineering model. Work streams describe what is being engineered, not the repositories, Terraform configurations, workspaces, subscriptions, projects, workflows, APIs, or other mechanisms through which the work is realized.

The three primary work streams remain **Institutive, Strata, and Kitting**.

### Institutive

Institutive establishes the Amiasea engineering model itself: the control-plane machinery, delivery structures, repositories, GitHub integration, HCP Terraform integration, APIs, identity, authorization, orchestration, webhooks, and other mechanisms necessary to operate the model.

Institutive is therefore about establishing the machinery that allows the other work streams and their promotion lifecycles to operate. It is not a stage or part of the Strata or Kitting lifecycle.

### Strata

Strata engineers the **Strata hosting model**.

The product of Strata is a **Strata artifact**, represented as one image. That image encompasses the hosting model together with the networking and collective capabilities required to establish the hosting environment.

The hosting model is bounded by hosting domains and may contain multiple clusters. A cluster is therefore an implementation boundary within the hosting model, not a promotional stage.

The Collective Model represents shared cloud capabilities that transcend an individual hosting domain.

Consequently, a Strata artifact should be understood as something like:

**Strata image = Networking + Hosting Model + Collective Model**

It is not:

**Strata image = speculative cluster + prospective cluster + operative cluster**

Those are different concepts.

The capacity, scaling characteristics, replication, and other production-tier characteristics of a realization of the Strata image are also separate concerns from the identity of the Strata artifact.

### Strata promotion

The Strata artifact has its own lifecycle and may progress through Speculative, Prospective, and Operative promotion.

Those stages describe the **state of the Strata artifact in its lifecycle**, not different kinds of Strata infrastructure.

A candidate Strata image can be realized in a speculative environment to establish that the hosting model actually works. It can then progress through more mature validation until it becomes an operative Strata image.

A successful Terraform apply is therefore only part of the validation. The meaningful test is whether the resulting hosting model can actually provide the capabilities that Kitting requires.

This is where Kitting becomes useful to Strata.

A Kitting Artifact can be deliberately constructed as a representative or synthetic workload and deployed into a candidate Strata image. That workload is effectively a test instrument for the hosting model.

It does not become Strata work merely because Strata uses it for validation.

### Kitting

Kitting is the work through which an application solution is packaged into a **Kitting Artifact**.

That distinction is important: **Kitting is the packaging process; the Kitting Artifact is the resulting product.**

The Kitting Artifact then has its own promotion lifecycle.

That lifecycle can also use Speculative, Prospective, and Operative stages, but those stages belong to the Kitting Artifact's lifecycle, not the Strata artifact's lifecycle.

A real Kitting Artifact represents an actual application solution. It is promoted through an established Strata hosting model.

So the two relationships are different:

Strata promotion asks:

**"Is this version of the hosting model ready to provide hosting?"**

Kitting promotion asks:

**"Is this application solution ready to be hosted?"**

### The two promotion streams

This is the part I think the document most needs to make explicit.

There are two independent artifact lifecycles:

**Strata artifact → Strata promotion → Speculative → Prospective → Operative**

and

**Kitting artifact → Kitting promotion → Speculative → Prospective → Operative**

They are independent, but they are not unrelated.

A Kitting Artifact fundamentally depends upon Strata. Therefore, a real Kitting Artifact is promoted against an established Strata image.

At the same time, Strata promotion can use Kitting Artifacts as validation workloads.

That produces a useful feedback relationship:

**Strata PR → candidate Strata image → validation Kitting Artifact**

while independently:

**Kitting PR → candidate Kitting Artifact → established Strata image**

This means the two artifacts can evolve independently while continuously testing their integration.

A candidate Strata image might even be tested against an existing operative Kitting Artifact. That is not the Kitting Artifact being promoted through its lifecycle; it is the existing artifact being used as a workload against which the candidate Strata image is validated.

Likewise, a Kitting PR is not testing a Strata PR simply because both happen to be in a speculative environment. It is testing against an established Strata image appropriate to that Kitting promotion stage.

### Delivery

I would also change the treatment of Delivery.

**Delivery is not a fourth work stream.**

It is the machinery through which the work streams and their artifact promotion mechanisms are established and operated.

That means a promotion implementation can coordinate both Strata and Kitting without implying that Strata and Kitting are one work stream.

This is also where HCP Terraform belongs conceptually.

HCP Terraform supplies institutional and execution primitives—workspaces, stacks, runs, state, configuration versions, variables, VCS integration, policies, approvals, etc.

Amiasea composes those primitives into its own promotion mechanics.

So HCP Terraform does not define "Speculative" or "Prospective" in the Amiasea sense. Amiasea does.

### The resulting boundary

I think the cleanest conceptual model is now:

**Institutive** establishes the engineering system.

**Strata** produces the hosting model artifact.

**Kitting** produces application-solution artifacts.

**Promotion** advances those artifacts through their respective lifecycles.

**Delivery** is the machinery that makes all of that possible.

And most importantly:

**Strata and Kitting have separate lifecycles.**

The dependency is directional:

**Kitting depends on Strata as its hosting substrate.**

But Strata can use Kitting as a validation workload.

That distinction explains the seemingly strange situation where a speculative Strata PR and a speculative Kitting PR may both exist at the same time while meaning completely different things. One is asking whether the **hosting model** works; the other is asking whether the **application solution** works on an established hosting model.
