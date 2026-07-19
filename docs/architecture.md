# Architecture

`gbv` is a deterministic hardware library first and a host application second. The same Machine used by the desktop Frontend is driven directly by unit tests, Conformance ROMs, tracing tools, and private compatibility checks.

```text
ROM Image + Hardware Profile + Boot policy + initial Save Data/RTC
                              │
                              ▼
                    ┌───────────────────┐
buttons ───────────▶│      Machine      │──────────▶ hardware Frame
run budget ────────▶│ deterministic and │──────────▶ audio samples
RTC synchronization▶│     headless      │──────────▶ dirty Save Data
                    └───────────────────┘───────────▶ events and traces
                              ▲
                              │
        headless CLI / test runner / raylib desktop Frontend
```

## Machine boundary

The Machine owns all emulated hardware state. Construction receives immutable ROM Image bytes, an explicit Hardware Profile, Boot Policy, optional Boot ROM bytes, initial Save Data, and caller-selected memory resources. The host may then apply an explicit RTC elapsed-time synchronization before execution.

After construction, host interaction is explicit:

- replace the complete joypad button state;
- advance until a Sub-tick budget or observable event;
- copy the completed hardware Frame into caller-owned output;
- drain deterministic audio samples into caller-owned output;
- copy dirty Save Data for host persistence;
- create or restore a versioned Snapshot;
- inspect state or configure deterministic debug stops.

The Machine never opens files, observes host time, sleeps, polls devices, creates windows, or writes audio. Veyr does not allow references to be returned from functions, so public outputs use caller-owned buffers or scoped access rather than borrowed references escaping a call.

## Events

The scheduler may stop for:

- Frame completion;
- audio output reaching a configured watermark;
- serial output or a Conformance ROM completion protocol;
- a breakpoint or watchpoint;
- CPU hard-lock;
- exhaustion of the caller's Sub-tick budget.

Every outcome includes enough timing and state identity for deterministic reproduction.

## Internal ownership

```text
Machine
├── Scheduler and Hardware Profile
├── SM83 CPU and interrupt state
├── Bus and access arbitration
├── Divider and timer
├── PPU and video memory
├── APU and sample generation
├── OAM DMA, GDMA, and HDMA
├── Joypad and serial port
├── Cartridge and Cartridge Controller
├── Save Data and RTC synchronization
└── Trace, debugger, and Snapshot state
```

All CPU-visible memory access passes through the Bus. Devices do not directly reach into one another's arrays when the hardware access path can be observed, blocked, redirected, or traced. The Bus owns address decoding, banking, unusable regions, access restrictions, DMA conflicts, and watchpoints.

The CPU advances through bus-visible operations on the master timeline. The PPU is dot-stepped. The timer derives behavior from divider edges. DMA is an active transfer, never an instantaneous memory copy.

## Cartridge model

Cartridge behavior is an explicit tagged model: ROM-only, MBC1, MBC2, MBC3, or MBC5 with separate capability flags such as RAM, battery, timer, and rumble. Header metadata selects and validates the controller family and capabilities. MBC1M and MBC30 extensions are detected only through documented structural rules or explicit configuration; title strings and hashes never select emulation rules.

The RTC receives deterministic elapsed-time synchronization from the host. Ordinary play may synchronize against elapsed wall time at explicit boundaries, while tests and replay use fixed or emulated time. Host epoch timestamps remain Persistence Record metadata, never Machine state.

## Video and audio

The core Frame uses hardware-oriented pixels: DMG shade indices or CGB 15-bit BGR values. The desktop Frontend converts them to RGBA8 for raylib.

The APU generates deterministic samples from Machine time. Host callbacks or buffer fullness may pace presentation but never clock emulated hardware. Fast-forward removes pacing without changing Machine transitions.

## Proposed repository shape

The first implementation uses one Veyr package with a narrow library facade and a headless command. The desktop Frontend may become a second path-dependent package when that separation is useful; root scripts coordinate packages because Veyr does not currently provide workspace orchestration.

```text
src/
├── lib.vyr
├── main.vyr
├── machine/
├── cpu/
├── bus/
├── devices/
├── ppu/
├── apu/
├── cartridge/
├── boot/
├── debug/
├── cli/
└── support/
apps/desktop/
testdata/self/
testdata/expected/
testdata/manifests/
scripts/
docs/
```

Exact files and module splits are implementation details. The durable boundary is the headless Machine versus host Frontends.
