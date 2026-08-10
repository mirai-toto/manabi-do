# Release pipeline: develop branch — draft

**Status: idea draft, not agreed.** Nothing here is scheduled. Written up so the
context is not lost; decisions marked "open" are still open.

## Why

Today every merge to `main` cuts a release: 18 tags between 2026-07-02 and
2026-08-08, twice on 2026-08-06 alone. More importantly, a push to `main` has
outward-facing effects that no second person reviews:

- `semantic-release` publishes a **public** GitHub Release with the AAB attached.
- `pages.yml` deploys the **public** docs site on any `docs/**` change.
- `build-android.yml` uploads to the Play **internal** track, which real testers
  receive.

The goal is for `main` to be protected (PR + approval) and effectively
deploy-only, with day-to-day work and looser rules living on `develop`.

## What already exists

Worth knowing before changing anything — some of the goal is already met:

| Intent | Today |
| --- | --- |
| CI runs outside `main` | Already: `ci.yml` has a bare `push:` (no branch filter) plus `pull_request:`, so it runs on every branch |
| Merging to `main` is manual | Already: it is a PR merge |
| Reaching production is manual | Already: `track: internal`, promotion happens by hand in Play Console |

So `develop` does not add a gate that is missing. What it adds is **batching**
and a place where the strict rules do not apply.

## Proposed shape

Use semantic-release's native prerelease channels rather than hand-rolling
anything:

```json
"branches": ["main", { "name": "develop", "prerelease": "beta" }]
```

`develop` cuts `v1.14.0-beta.1`, `main` cuts `v1.14.0`.

### Changes required

1. **`.releaserc.json`** — the `branches` array above.
2. **`.github/workflows/semantic-release.yml`** — its `workflow_run` trigger
   filters `branches: [main]`; add `develop`.
3. **`.github/workflows/build-android.yml`** — fires on any `release: published`,
   **including prereleases**. Without a guard, every beta publishes to the same
   track as a stable release. Needs either
   `if: github.event.release.prerelease == false` on the Play step, or a track
   expression selecting `internal` vs the stable track.
4. **`.github/workflows/pages.yml`** — currently `push: branches: [main]`.
   Probably stays on `main` (docs should publish on release), but confirm.
5. **Branch protection** — `main`: require PR + 1 approval. `develop`: today's
   rules. GitHub settings, not code.
6. **Default branch** — likely `develop`, so new PRs base off it automatically.

## Open decisions

- **Track mapping.** `develop → internal` is obvious. For `main`:
  `production` (PR approval replaces the manual Play promotion),
  `internal` (nothing about delivery changes), or a closed track (middle ground,
  needs the track configured on the listing first).
- **Whether `develop` should version at all.** The prerelease channel gives beta
  tags, but `develop` could equally cut nothing and leave all tagging to `main`.
- **Solo-repo overhead.** Requiring approval on `main` in a single-maintainer
  repo means either self-approval or the rule blocking its own author. Worth
  checking how GitHub behaves here before committing to it.
- **Is a branch the right fix for the churn?** A smaller alternative: give
  `semantic-release.yml` a `workflow_dispatch` trigger instead of `workflow_run`,
  and cut releases deliberately. One trigger changed, no branching model, no
  forward/back-merging. This does **not** address the protection goal, only the
  release cadence — if the protection is the point, it is not a substitute.

## Notes

- PR #14 currently targets `main`. If `develop` is created, decide whether it is
  retargeted or lands as the last direct-to-`main` PR.
- The Play "What's new" wiring on this branch is independent of all of the
  above and can land on its own.
