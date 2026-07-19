# Repository Guidelines

## Project identity

This repository contains `gbv`, a from-scratch Game Boy and Game Boy Color
emulator written in Veyr. Keep the project name lowercase in prose, issue
titles, package names, and commands. Hardware names and acronyms such as DMG,
CGB, SM83, PPU, APU, DMA, and RTC retain their conventional capitalization.

Read `CONTEXT.md` first for the domain language, then `docs/roadmap.md`,
`docs/issue-plan.md`, and the relevant subsystem document before changing the
architecture or implementation plan. The decisions in `docs/adr/` are durable
constraints unless a superseding ADR is accepted.

## Linear routing

All `gbv` work is tracked in the lg2m Linear workspace:

- team: Development (`DEV`)
- team ID: `43fc3a22-78de-44d9-8f25-c4b95379e882`
- project: `gbv`
- project ID: `8cfda7a8-483b-4789-87bf-7b7c7873556d`
- project slug: `fac19bd02238`
- project URL: <https://linear.app/lg2m/project/gbv-fac19bd02238>

Every implementation issue must belong to the `gbv` project and exactly one
ZeroVer milestone: `v0.0.1` through `v0.0.7`, or stable `v0.1.0`. Check an
issue's `blocked by` relations before starting it and keep the relation graph
current when reality changes.

Language, compiler, standard-library, core-library, or vendor-library gaps are
owned by the `veyr/veyrc` Linear project. Search for an existing upstream owner
first. Link the `gbv` issue as blocked by that Veyr issue only after a minimal
project-owned reproducer proves the capability is required; do not put compiler
implementation work in this repository.

## Product and architecture boundaries

The deterministic `Machine` owns emulated state and time. Host concerns such as
windows, controllers, audio devices, files, wall clocks, and CLI parsing belong
behind adapters. The core must remain usable headlessly, and deterministic
tests must not depend on host timing.

Do not add per-title hacks, copyrighted ROMs, Nintendo boot ROMs, or proprietary
assets. Public test fixtures must be redistributable and have recorded
provenance. Users provide commercial games and optional boot ROMs themselves.

## Change discipline

Implement the smallest unblocked Linear slice that produces observable value.
Add the narrowest deterministic test or public conformance ROM that proves the
behavior, preserve the published trace/hash contracts, and update the owning
document when a domain or architecture decision changes. Keep commits narrow
and mention the Linear identifier in the pull request.
