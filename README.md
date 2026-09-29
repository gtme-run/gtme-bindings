# gtme-bindings

The bindings registry for [gtme](https://github.com/gtme-run/gtme):
an index (`index.json`) over declarative adapters, plus the **verified** set
maintained and fixture-tested here. A binding is a directory holding one
`binding.yaml` (validated against gtme's `spec/binding-schema.json`) and
`fixtures/conformance.json` — data the gtme engine interprets; it cannot
execute code.

## Install

```
gtme adapters search <text>
gtme adapters add github.com/gtme-run/gtme-bindings/<dir>@main
```

`add` verifies before anything installs: schema, the fixtures run offline,
and the hosts and credentials the binding will use are printed. The install
is pinned (`.source.json` records the resolved commit and content hash);
`gtme adapters update <id>` is the only thing that moves a pin.

## Tiers

- **verified** — maintained in this repository; CI runs every binding's
  fixtures on every change. An entry whose fixtures stop passing stops
  being listed.
- **community** — listed by pull request, hosted in the author's own
  repository, fixtures required (`gtme adapters add` runs them before
  installing).

An entry is a binding unless it says `kind: process`. A process entry is a
prebuilt process adapter for logic a binding may not hold (gtme ADR-063):
one archive per platform holding `manifest.json` and an executable `run`,
each pinned by its sha256, built by gtme-run CI from a tagged commit.
Process entries are verified only; `instantly/add-to-campaign` is one, built
by gtme's own release. `gtme adapters add <id>` installs the archive for
your platform and refuses a checksum mismatch.

## Contribute a binding

1. Author it: `gtme help --bindings` prints the schema, the discovery path,
   and a worked example. Keep fixtures beside it, with a `config` member
   (and `input`, for a role that consumes records) so `gtme adapters
   verify` can drive the run.
2. Verify locally: `GTME_ADAPTER_PATH=$PWD gtme adapters verify <id>`.
3. Open a PR — a verified-tier binding adds its directory here; a
   community entry adds only an `index.json` row pointing at your
   repository, with its content hash (`scripts/hash.sh <dir>`).

Fixtures must never contain real personal data: synthesize values, keep
real shapes.

A deliver binding that declares `idempotency_scope` must name a config key
holding a **stable identifier** of the destination: an id, an API slug, a
file path, a URL. Never a display name the destination's owner can rename:
the scope is where gtme's delivery dedupe lives, so a renamed campaign or
list would become a new destination and receive everyone again (gtme
ADR-062). Where the identifier has a shape, constrain it in
`config_schema` (a `pattern` with a `description` saying where to find
it), so a name fails `gtme plan` with that description.

## The content hash

`scripts/hash.sh <dir>` — sha256 over the binding directory's files
(sorted slash paths, each written as `path NUL body NUL`, `.source.json`
excluded). It must match the entry's `sha256`; `gtme adapters add`
refuses a mismatch.
