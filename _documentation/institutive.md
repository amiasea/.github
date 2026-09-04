# Institutive: Prereleases, Promotion, and Provenance

## Overview

Institutive does not treat its own Git branches as environments. Institutive is a single institutive engineering delivery context, deployed in its institutive production context. Its release lifecycle is separate from the engineering environments that Institutive models and governs.

The release lifecycle of Institutive is expressed through artifact release versions and their promotion ceremony:

```text
development branch

    ↓

prerelease candidate lineage

    ↓

release
```

A prerelease is therefore not an environment and not a slot. It is a concrete candidate state of an artifact that is being evaluated for promotion into a release position.

## Prerelease Meaning

A prerelease such as:

```text
v1.0.0-rc.1
```

represents a distinct release candidate state. Successive candidates are distinct states even when they share the same eventual base version:

```text
v1.0.0-rc.1
v1.0.0-rc.2
v1.0.0-rc.3
```

Each candidate may differ in source, tests, dependencies, configuration, generated output, build behavior, or other release-defining material. The important requirement is that each candidate is a separately identifiable and reproducible release state.

The `rc.N` component is therefore meaningful version progression. A new release candidate should increment `N` rather than overwrite an earlier candidate under the same version.

## Release Lineage

A release candidate establishes a release lineage. The preferred rule is that a final release may only terminate the prerelease lineage with the same base semantic version:

```text
v1.0.0-rc.1
v1.0.0-rc.2
v1.0.0-rc.3
        ↓
     v1.0.0
```

A candidate lineage may be abandoned entirely. An abandoned `v1.0.0-rc.N` does not need to produce `v1.0.0`.

If the next release has a different base version, it should establish its own candidate lineage:

```text
v1.0.0-rc.3

    ↓

abandoned

v1.0.1-rc.1
v1.0.1
```

This avoids reinterpreting one candidate lineage as the precursor to a different released version.

## Commit Provenance Invariant

A final release must be created from the exact commit ref that carries the latest prerelease candidate for that release lineage.

For example, if the latest candidate is:

```text
v1.0.0-rc.3
    ↓
commit abc123
```

then the final release:

```text
v1.0.0
```

must also be tagged at:

```text
commit abc123
```

The final release must not be created from a different commit, even when that commit belongs to the same branch or contains the same intended changes.

This establishes that the released artifact is the terminal accepted state of the candidate that was most recently evaluated, rather than a separate source state that merely shares the same base SemVer.

The candidate lineage may still evolve through multiple prereleases before the final release is created:

```text
v1.0.0-rc.1 → commit A
v1.0.0-rc.2 → commit B
v1.0.0-rc.3 → commit C
                         ↓
                    v1.0.0 → commit C
```

If additional source, tests, dependencies, configuration, or other release-defining material changes after `v1.0.0-rc.3`, a new prerelease must be produced before `v1.0.0` can be released.

## Provenance Invariant

Every production release should have a corresponding prerelease lineage.

For example:

```text
v1.0.0-rc.1
v1.0.0-rc.2
v1.0.0-rc.3
v1.0.0
```

is a valid release history.

By contrast, this should not be the normal release model:

```text
v1.0.0-rc.3
v1.0.1
```

because `v1.0.1` has no candidate lineage of its own.

This establishes a provenance invariant:

> A released version is the terminal accepted state of a candidate lineage for that same base version, and the release tag is placed on the same commit ref as the latest prerelease tag in that lineage.

The prerelease lineage is therefore part of the release's provenance, not merely a convenience for testing.

## ACA Revision Model

Azure Container Apps revisions provide the runtime realization of these candidate states.

A single institutive ACA application may retain multiple immutable revisions:

```text
ACA application

├── revision for v1.0.0-rc.1
├── revision for v1.0.0-rc.2
├── revision for v1.0.0-rc.3
└── revision for v1.0.0
```

Promotion positions are represented by revision labels rather than by separate ACA applications or environment-specific copies of Institutive.

The intended labels are:

```text
prerelease → current candidate revision
release    → current released revision
```

When a new prerelease is deployed, the `prerelease` label moves to the new revision. When a final release is deployed, the `release` label moves to the new final-release revision.

Older revisions remain available as revision history and may become unlabeled.

For example:

```text
v1.0.0-rc.1 → prerelease
v1.0.0-rc.2 → prerelease
v1.0.0-rc.3 → prerelease
v1.0.0      → release
```

results conceptually in:

```text
v1.0.0-rc.1   unlabeled
v1.0.0-rc.2   unlabeled
v1.0.0-rc.3   unlabeled
v1.0.0        release
```

If another candidate is produced:

```text
v2.0.0-rc.1
```

then it receives the `prerelease` label while the existing production release remains labeled `release`.

## Candidate Revisions Are Not Slots

A prerelease is not a blue/green slot waiting to be swapped into production.

The candidate itself is a distinct release artifact state. A later final release is another artifact state and is deployed as another revision.

For example:

```text
v1.0.0-rc.3

    ↓

prerelease revision

    ↓

E2E validation
```

followed by:

```text
v1.0.0

    ↓

new revision

    ↓

release label
```

The `v1.0.0-rc.3` revision is not transformed into `v1.0.0`. The final release is a new release artifact and a new runtime revision.

## SemVer and Candidate Evolution

The base semantic version identifies the release lineage, while the prerelease identifier identifies the candidate state within that lineage.

Thus:

```text
v1.0.0-rc.1 < v1.0.0-rc.2 < v1.0.0-rc.3 < v1.0.0
```

The final release does not need to be identical to `rc.1` or even to `rc.3` at the source-code level. The candidate sequence exists precisely because the release-defining state may continue to evolve during validation.

A release version therefore represents more than a Git commit. Its provenance may include the source state, tests, dependencies, configuration, build outputs, release metadata, and other material that defines the artifact being accepted.

The commit provenance rule nevertheless establishes a precise terminal point: the final release tag must identify the same commit ref as the latest prerelease candidate that preceded it.

## Promotion Ceremony

The release ceremony is driven by the artifact release contract.

A typical sequence is:

```text
artifact release published

        ↓

Stack deployment references the release-contract tag

        ↓

new ACA revisions are created where applicable

        ↓

GitHub release metadata determines prerelease/release status

        ↓

revision receives `prerelease` or `release` promotion label

        ↓

E2E validation is performed for a prerelease

        ↓

accepted final release occupies the `release` position
```

The Stack has one conceptual institutive state. It does not model `prerelease` and `release` as separate environments.

The artifact contract reference advances sequentially, for example:

```text
v1.0.0-rc.1
v1.0.0
v2.0.0-rc.1
v2.0.0-rc.2
v2.0.0
```

Each new release-contract tag supersedes the prior reference while older ACA revisions can remain as historical runtime realizations.

## Institutive Is Not Environment-Segmented

Institutive itself is not divided into development and production environments merely because its artifact promotion uses development and main branches.

A branch is not an environment.

Likewise, a prerelease API is not a separate Institutive engineering context. It is another revision of the same institutive API participating in the same engineering delivery model.

The institutive Institutive instance can therefore contain shared resources such as:

```text
API

Database

ACA Apps

ACA Jobs

Logic App

Integration Account

GitHub integration

Key Vault
```

while the engineering environments governed by Institutive remain part of the modeled delivery context:

```text
development

prospective

operative
```

Those are different axes.

## Core Rules

1. **Institutive has one institutive engineering delivery context.**

2. **Git branches do not imply Institutive runtime environments.**

3. **Prereleases are release candidates, not environments or slots.**

4. **Each `rc.N` is a distinct release candidate state.**

5. **`rc.N` should advance sequentially within a release lineage.**

6. **A candidate lineage may be abandoned without producing a final release.**

7. **A final release should correspond to a prerelease lineage with the same base SemVer.**

8. **The final release tag must be on the same commit ref as the latest prerelease tag in its lineage.**

9. **If release-defining material changes after the latest prerelease candidate, a new prerelease must be produced before the final release.**

10. **A final release is a new artifact state and therefore a new ACA revision; it is not a slot swap.**

11. **The `prerelease` and `release` ACA labels are moving promotion positions.**

12. **Older ACA revisions may remain as historical provenance even after losing their labels.**

13. **The artifact contract release tag is the sequential promotion pointer for the institutive Stack.**

14. **A production release should be traceable to the candidate lineage that preceded it.**
