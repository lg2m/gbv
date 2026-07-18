# Roadmap

The roadmap grows one deterministic Machine through increasingly strong hardware evidence. Each milestone has an observable exit condition; “code exists” is never enough.

## v0.0.1 — scientific foundation

Deliver:

- reproducible Veyr toolchain pin and package build outside the Veyr repository;
- ROM Image inspection and typed validation;
- deterministic Machine shell and 8,388,608 Hz scheduler;
- one project-owned serial-pass micro-ROM;
- pinned fixture manifest/fetch mechanism;
- headless runner with bounded completion protocols;
- stable trace records and canonical state hashes;
- required source/tracer CI plus a nonblocking Veyr-main canary.

Exit: a clean checkout builds, validates a self-owned ROM Image, executes it through the loader/Bus/CPU/serial path, and reports the same outcome and state hash twice.

## v0.0.2 — headless SM83

Deliver:

- complete base and CB opcode classifications;
- bus-visible load/store, arithmetic, control-flow, stack, rotate/shift, and bit operations;
- exhaustive local ALU/flag tests;
- interrupt entry, delayed `EI`, `HALT`, the HALT bug, `STOP`, and invalid-opcode hard-lock;
- disassembly and bounded instruction/bus traces;
- required CPU-only Mooneye and applicable Blargg semantics gates, with platform timing owned by later device milestones.

Exit: the pinned CPU matrix has no unexplained required failure under the initial DMG Hardware Profile.

## v0.0.3 — accurate DMG platform and video

Deliver:

- complete DMG address map, I/O registers, interrupts, divider/timer, joypad, serial, and OAM DMA;
- CPU access restrictions and DMA bus conflicts;
- dot-stepped LCD/LY/STAT state machine;
- OAM scan, background/window fetcher, Pixel FIFOs, object fetching, priority, and variable Mode 3;
- exact project-owned frame fixtures, `dmg-acid2`, and selected Mealybug timing results;
- deterministic scripted-input replay.

Exit: exact DMG structural and selected mid-scanline Frame gates pass for the initial DMG profile.

## v0.0.4 — robust DMG cartridges and audio

Deliver:

- ROM-only, MBC1/MBC1M, MBC2, MBC3/MBC30, and MBC5 controllers;
- crash-safe battery Save Data and deterministic MBC3 RTC behavior;
- four APU channels, frame sequencer, stereo mixing, filtering, and deterministic resampling;
- required mapper, RTC, and DMG sound suites;
- broader public-homebrew execution.

Exit: supported DMG cartridge and APU matrices have no unexplained required failures, and Save Data/RTC survives process restart.

## v0.0.5 — playable CGB

Deliver:

- explicit CGB Mode and DMG Compatibility Mode;
- VRAM/WRAM banking, palette RAM, tile attributes, and CGB priority;
- normal/double-speed switching without changing PPU cadence;
- CGB OAM DMA behavior, GDMA, and HDMA;
- CGB audio differences and compatibility palettes;
- exact `cgb-acid2`, selected Mooneye, and selected Mealybug CGB gates.

Exit: exact CGB structural and timing gates pass for the initial CGB profile, with deterministic saves and RTC.

## v0.0.6 — desktop beta

Deliver:

- raylib video, keyboard/gamepad input, and PCM audio adapters;
- integer scaling, pacing, fast-forward, volume, and clean shutdown;
- ROM/save/config CLI and clear unsupported-cartridge diagnostics;
- optional user Boot ROM configuration;
- artifact-free local compatibility workflow;
- Pokémon Red, Blue, Yellow, Gold, Silver, and Crystal milestone reports from legally owned dumps.

Exit: public homebrew and the private compatibility milestones can be played in real time with stable input, video, audio, Save Data, and RTC.

## v0.0.7 — compatibility beta

Deliver:

- versioned Snapshots containing every hidden hardware pipeline state;
- deterministic input recording/replay;
- register, memory, PPU, APU, DMA, and mapper inspection;
- breakpoints, watchpoints, and bounded failure artifacts;
- exhaustive pinned test report across supported Hardware Profiles;
- real-time and long-run regression budgets;
- release-candidate fixture/license audit.

Exit: no required result is unexplained, long replays remain deterministic, and every known failure links to an actionable issue.

## v0.1.0 — stable DMG+CGB flagship

Deliver:

- stable documented Machine facade;
- stable Save Data contract and declared Snapshot compatibility policy;
- reproducible Linux x86-64 source and binary artifacts;
- checksums, build provenance, exact Veyr and Nix inputs, security and contributor documentation;
- public compatibility-report format and documented non-goals.

Exit: a new contributor can build, run the public matrix, reproduce a failure, and use a legally supplied game without cloning Veyr or relying on undocumented assets.

## Beyond v0.1.0

Potential later projects include additional hardware revisions, local two-Machine link cable, netplay transport, Super Game Boy, accessories, rewind, other host platforms, and presentation filters. They do not weaken or delay the stable DMG+CGB core.
