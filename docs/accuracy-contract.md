# Accuracy contract

`gbv` reproduces observed hardware behavior. A game appearing playable is useful compatibility evidence, but it is never a substitute for a hardware-derived oracle.

## Determinism

Identical ROM Image bytes, Hardware Profile, Boot policy, initial Save Data, RTC state, input script, and Sub-tick budget must produce identical:

- event sequence and execution trace;
- Machine state hashes;
- hardware Frames;
- audio samples;
- resulting Save Data.

Host scheduling, display refresh, audio-device periods, locale, time zone, filesystem ordering, and wall-clock timing must not alter those outputs.

## Evidence hierarchy

When sources disagree, use this order:

1. a hardware-backed test, capture, or reproducible experiment for the selected Hardware Profile;
2. Game Boy: Complete Technical Reference;
3. current Pan Docs;
4. the RGBDS SM83 instruction reference and gb-opcodes data;
5. differential comparison with a mature emulator as an investigation aid.

A differential match is supporting evidence, not proof. A disagreement creates a research task until hardware or a hardware-derived oracle resolves it.

## No compatibility hacks

The Machine must never branch on a game title, commercial ROM hash, or publisher identity to replace missing hardware behavior. Quirks live in Hardware Profiles or Cartridge Controller models and require evidence. The documented CGB Boot ROM compatibility-palette algorithm may use header title/licensee fields because that is emulated firmware behavior, not a compatibility hack.

Frontend presentation preferences, such as color correction or scaling, may be title-independent options outside the Machine and never affect emulated state.

## Conformance accounting

Every pinned public test result is explicit for each supported Hardware Profile:

- `required`: must pass;
- `known-fail`: linked to an open issue with captured evidence;
- `not-applicable`: accompanied by a hardware reason.

Tests may not disappear from a manifest merely because they fail. A stable release has no unexplained required-suite result.

## Failure evidence

A failed ROM or replay gate should retain a bounded artifact containing:

- Hardware Profile, Boot Policy, ROM/test identity, and input identity;
- Sub-tick and CPU instruction/micro-operation position;
- registers, flags, interrupt state, and recent bus trace;
- divider/timer internals;
- PPU mode, line, Dot, fetcher/FIFO and STAT state;
- DMA and Cartridge Controller state;
- frame or audio digest difference;
- a one-command reproduction selector.

## Performance

Correctness comes before speed. Optimizations must preserve deterministic outputs and conformance results. The project measures real-time headroom and regression budgets, but it does not replace observable hardware transitions with approximations merely to meet a benchmark.
