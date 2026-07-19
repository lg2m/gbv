# Veyr boundary

The ownership rule is:

> Hardware emulation and application policy stay in `gbv`. Only a proven language defect or a broadly reusable platform contract belongs in Veyr.

## Belongs in `gbv`

- SM83 execution, interrupts, timing, Bus behavior, PPU, APU, DMA, joypad, and serial hardware;
- Cartridge parsing, controllers, RTC semantics, Save Data, and Snapshots;
- the test-ROM runner, completion protocols, trace format, and debugger;
- input mapping, pacing, configuration, compatibility reporting, and release policy;
- emulator-specific binary cursors, ring buffers, resampling, and atomic persistence helpers until their general API is proven.

Project code may use ordinary Veyr language facilities to implement all of these. Difficulty or volume alone does not justify a compiler feature.

## Already supplied by Veyr

The current language and libraries provide the required Linux foundation:

- fixed-width integers, explicit wrapping operations, bit operations, enums, matches, arrays, bytes, and deterministic ownership;
- filesystem byte I/O, monotonic and real-time clocks, formatting, process execution, and package tests;
- `vendor.raylib` presentation of a 160×144 RGBA8 framebuffer, keyboard/gamepad polling, and signed-16 stereo PCM queuing, delivered by DEV-343 and DEV-344;
- C ABI, native package metadata, and standalone out-of-repository builds.

There is no proven compiler or language blocker for starting the Machine implementation.

## Implement locally before promotion

The following may eventually belong in `core` or `std`, but begin inside `gbv`:

- bounded binary reader/writer;
- complete endian decoding helpers;
- ring buffer;
- fixed-point resampler utilities;
- atomic replace-file helper;
- general command-line parsing.

Promotion requires at least two non-`gbv` use cases, a stable allocator/error contract, package-owned tests, and a clearly more general vocabulary than the emulator domain.

## Conditional Veyr work

Create or reuse a `veyr/veyrc` issue only after a minimal standalone reproducer proves:

- a miscompilation or compiler crash;
- unsound ownership or aliasing;
- required integer, bit, layout, or packing behavior cannot be expressed correctly;
- a broken C ABI or callback contract;
- a reusable host primitive cannot reasonably be written in Veyr code.

The issue must state expected language/library behavior, include the reproducer, and add conformance or golden acceptance. It blocks only the affected `gbv` issue, not the whole project.

The current raylib push-audio facade is sufficient for initial playback but does not promise gap-free output on every native device. Callback-backed audio reuses DEV-504 under DEV-503 only if real `gbv` evidence proves the push contract cannot meet the production-audio acceptance criteria; the full DEV-503 raylib API epic is otherwise not a blocker.

Additional operating systems require a compiler target, hosted `core`/`std` rows, and a matching tested raylib row. They are portability dependencies, not blockers for the Linux release.

Token-free public contributor installation is owned by DEV-314 and DEV-317. It blocks the stranger-facing stable-release acceptance, not local Machine development.

## Cross-project workflow

1. Reproduce the inability in a `gbv` vertical slice.
2. Search the `veyr/veyrc` project for an existing owner whose documented acceptance resolves it.
3. Reuse and link that owner directly when it fits.
4. For a new defect or missing contract, reduce the problem to the smallest standalone Veyr program and create the upstream issue with its own acceptance gate.
5. Link the upstream issue as blocking only the affected `gbv` issue.
6. Continue unrelated Machine work.
7. Remove any temporary workaround after the upstream gate passes.
