# Testing strategy

`gbv` treats correctness as a layered trust problem. No single suite, emulator, commercial game, or green CI row is a complete oracle.

## Layer 1: component tests

Colocated Veyr tests exercise pure or tightly bounded state transitions without running a ROM Image:

- exhaustive arithmetic/flag combinations, including `DAA` and signed `SP+e8`;
- opcode metadata completeness and decode classification;
- cartridge header, checksum, size, and malformed-input handling;
- Cartridge Controller bank-selection matrices;
- MBC3 RTC latch, halt, carry, and offline progression with a fake clock;
- divider/timer edges, interrupt entry, and STAT-line transitions;
- PPU fetch, priority, palette, and Pixel FIFO transitions;
- APU channel and deterministic resampler behavior;
- Snapshot round trips and corruption rejection.

## Layer 2: project-owned micro-ROMs

Small, reproducibly built ROM Images exercise a complete path through loader, Bus, CPU, device, and observable result. They begin from Post-boot Start unless a redistributable Boot ROM is explicitly part of the fixture.

Micro-ROMs provide narrow, stable failures and cover serial completion, exact traces, frame digests, audio digests, Save Data, and invalid-state behavior. Their source, build command, compiler pin, binary, and expected result are committed.

## Layer 3: public hardware-derived Conformance ROMs

The core matrix includes applicable subsets of:

- Mooneye for model-aware CPU, interrupt, timer, DMA, memory, and acceptance behavior;
- `dmg-acid2` and `cgb-acid2` for structural PPU framebuffer results;
- Mealybug Tearoom for mid-scanline PPU timing;
- SameSuite for APU, DMA, interrupt, and PPU research tests;
- `rtc3test` for MBC3 RTC behavior;
- Blargg CPU, timing, memory, HALT, OAM, and sound tests when their exact provenance and redistribution policy are recorded.

Each test is pinned in a manifest with source URL, commit or release, SHA-256, license status, applicable Hardware Profiles, Boot Policy, completion protocol, Sub-tick budget, expected result, and issue-backed disposition.

Supported completion protocols include serial text, Mooneye register/breakpoint state, exact Frame digest, exact audio digest, and bounded final Machine-state digest.

## Layer 4: differential investigation

Open test programs may be compared against a mature emulator such as SameBoy using trace checkpoints, serial output, exact-cycle Frame hashes, or resulting Save Data. A mismatch locates disagreement; it does not decide which implementation is correct. Hardware evidence resolves the issue.

## Layer 5: private commercial compatibility

Legally obtained commercial ROM Images may be tested through an ignored local manifest. Public CI and release artifacts never require or upload them.

Pokémon checkpoints cover boot, new game, menus, overworld, battles, Save Data, process restart, MBC3 elapsed-time behavior, long deterministic runs, fast-forward equivalence, and native CGB startup. The desktop milestone runs those pre-Snapshot checkpoints; the compatibility beta reruns the private matrix with Snapshot restore. These are Compatibility Reports, not conformance oracles.

## CI tiers

| Tier | Trigger | Required evidence |
|---|---|---|
| T0 source | Every PR | formatting, package check/build/test, manifest/license validation |
| T1 tracer | Every PR | project-owned micro-ROMs and determinism/state-hash smoke |
| T2 conformance | Every PR, impact selected | bounded subsystem suite and relevant exact Frame/audio gates |
| T3 exhaustive | Nightly | full pinned matrix, long replay, persistence, differential and performance reports |
| T4 release | Release candidate | no unexplained required failures, real-time floor, reproducible artifacts, private compatibility fleet |

Required CI uses a pinned known-green Veyr toolchain. A nonblocking nightly canary builds against current Veyr `main` so `gbv` exposes toolchain regressions without making ordinary emulator work depend on a moving compiler.

Until Veyr's package integration/process-test contracts are complete, external ROM execution is owned by a focused `gbv` shell harness while component tests remain under `veyr test`.

## Failure artifacts

CI retains bounded diagnostic artifacts described by the [accuracy contract](./accuracy-contract.md). Proprietary inputs and data derived from commercial ROM Images are never uploaded.
