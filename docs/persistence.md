# Persistence, Snapshots, and replay

`gbv` separates cartridge persistence from emulator debugging state.

## Save Data

Save Data contains only state that physical cartridge hardware retains, principally battery-backed RAM and deterministic RTC state. It is portable across compatible `gbv` versions and remains independent of host presentation settings.

The Frontend owns paths and filesystem operations. It wraps Save Data in a Persistence Record carrying ROM identity, format metadata, and the host timestamp used to calculate later RTC elapsed time. It writes a temporary file, synchronizes according to the release policy, and atomically replaces the previous generation. Partial writes must not destroy the last valid save.

## Snapshot

A Snapshot captures the complete Machine, including hidden in-flight state:

- CPU instruction and bus phase;
- interrupt and speed-switch state;
- divider/timer reload windows;
- PPU fetcher, Pixel FIFOs, line, Dot, and STAT state;
- active DMA transfers;
- APU channel, sequencer, filter, and resampler phase;
- Cartridge Controller and RTC state;
- serial, joypad, debugger, and scheduler state.

Snapshot files are versioned and validated. Pre-v1 encodings may change; stable compatibility is promised only after a format is explicitly declared stable. A Snapshot never replaces battery Save Data.

## State hashing

The deterministic test harness hashes a canonical representation of Machine state at explicit Sub-ticks. Hashing excludes allocator addresses, host paths, wall-clock timestamps, presentation settings, and padding bytes.

The hash is a regression oracle and identity aid, not a cryptographic signature of legitimate ROM ownership.

## Input replay and rewind

An input recording contains Hardware Profile, initial-state identity, timestamped complete button states, RTC synchronizations, and run boundaries. Replaying it must reproduce the same events and state hashes.

Rewind is post-v1 unless promoted separately. It composes periodic Snapshots with deterministic input replay rather than introducing a second execution model.
