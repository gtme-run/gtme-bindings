# gtme-bindings

The bindings registry for [gtme](https://github.com/elegant-atomics/gtme):
an index (`index.json`) over declarative adapters, plus the **verified** set
maintained and fixture-tested here. A binding is a directory holding one
`binding.yaml` (validated against gtme's `spec/binding-schema.json`) and
`fixtures/conformance.json` — data the gtme engine interprets; it cannot
execute code.

## Install

```
gtme adapters search <text>
gtme adapters add github.com/elegant-atomics/gtme-bindings/<dir>@main
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

## The content hash

`scripts/hash.sh <dir>` — sha256 over the binding directory's files
(sorted slash paths, each written as `path NUL body NUL`, `.source.json`
excluded). It must match the entry's `sha256`; `gtme adapters add`
refuses a mismatch.
