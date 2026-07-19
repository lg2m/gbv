# Hardware models

`gbv` models real hardware identities explicitly. It does not combine convenient behavior from several revisions into a fictional generic Game Boy.

## Hardware Profile

A Hardware Profile records:

- hardware family and concrete revision;
- execution mode: native DMG, native CGB, or CGB DMG Compatibility Mode;
- initial register and memory behavior known to differ by revision;
- undefined, unusable, and open-bus behavior where evidence supports a revision-specific rule.

Boot Policy is separate run configuration so the same physical profile can be tested with a user-supplied Boot ROM or a documented Post-boot Start.

CPU speed is runtime Machine state rather than fixed profile metadata because CGB software may switch between normal and double speed.

## Initial reference profiles

The first implementation supports:

1. one well-understood late-production DMG revision;
2. CGB-D in CGB Mode, selected because public model-specific image oracles cover it;
3. the same CGB revision in DMG Compatibility Mode.

Selecting the exact initial DMG revision remains an evidence-gathering implementation issue. Every choice must be supported by public hardware-derived tests and documented startup behavior rather than convenience.

Additional revisions are added only with their own test applicability and known behavioral differences. Candidate later profiles include early DMG, Game Boy Pocket, early CGB, and Game Boy Advance compatibility behavior; none is silently aliased to an existing profile.

## Cartridge interaction

The ROM Image header declares whether software supports or requires CGB features. It may reject an incompatible requested profile or determine the execution mode within an already selected CGB profile. It does not decide which physical revision `gbv` emulates.

Cartridge controller families and capabilities are selected from header metadata and validated against image and RAM sizes. MBC1M wiring is not uniquely declared by the header and therefore requires documented structural detection or explicit user configuration. Game title strings and ROM hashes never select hardware behavior.

## Test applicability

Every Conformance ROM manifest entry declares the profiles to which its oracle applies. Results are one of:

- `required`: the test must pass for this profile;
- `known-fail`: a linked issue explains the divergence;
- `not-applicable`: the manifest records why the hardware profile is outside the test's domain.

Compatibility Reports likewise record the Hardware Profile, Boot Policy, `gbv` version, ROM revision identity, and configuration. A result on one profile is not silently generalized to another.

The primary initial evidence sources are the [Mooneye test suite](https://github.com/Gekkio/mooneye-test-suite), [Game Boy: Complete Technical Reference](https://gekkio.fi/files/gb-docs/gbctr.pdf), and [Pan Docs](https://gbdev.io/pandocs/).
