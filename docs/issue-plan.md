# Published issue graph

Each numbered tracer slice produces an observable end-to-end result and can be assigned independently after its blockers complete. The Linear source of truth is the [gbv project](https://linear.app/lg2m/project/gbv-fac19bd02238), with [DEV-636](https://linear.app/lg2m/issue/DEV-636) as the umbrella story.

## Linear publication

| Milestone | Published slices |
|---|---|
| `v0.0.1` | F01 [DEV-637](https://linear.app/lg2m/issue/DEV-637), F02 [DEV-639](https://linear.app/lg2m/issue/DEV-639), F03 [DEV-638](https://linear.app/lg2m/issue/DEV-638), F04 [DEV-640](https://linear.app/lg2m/issue/DEV-640), F05 [DEV-641](https://linear.app/lg2m/issue/DEV-641) |
| `v0.0.2` | C01 [DEV-642](https://linear.app/lg2m/issue/DEV-642) through C06 [DEV-647](https://linear.app/lg2m/issue/DEV-647) |
| `v0.0.3` | D01 [DEV-648](https://linear.app/lg2m/issue/DEV-648) through D08 [DEV-655](https://linear.app/lg2m/issue/DEV-655) |
| `v0.0.4` | K01 [DEV-656](https://linear.app/lg2m/issue/DEV-656) through K05 [DEV-660](https://linear.app/lg2m/issue/DEV-660); A01 [DEV-661](https://linear.app/lg2m/issue/DEV-661) through A03 [DEV-663](https://linear.app/lg2m/issue/DEV-663) |
| `v0.0.5` | G01 [DEV-664](https://linear.app/lg2m/issue/DEV-664) through G06 [DEV-669](https://linear.app/lg2m/issue/DEV-669) |
| `v0.0.6` | H01 [DEV-670](https://linear.app/lg2m/issue/DEV-670) through H04 [DEV-673](https://linear.app/lg2m/issue/DEV-673) |
| `v0.0.7` | Q01 [DEV-674](https://linear.app/lg2m/issue/DEV-674) through Q03 [DEV-676](https://linear.app/lg2m/issue/DEV-676) |
| `v0.1.0` | R01 [DEV-677](https://linear.app/lg2m/issue/DEV-677) plus umbrella [DEV-636](https://linear.app/lg2m/issue/DEV-636) |

## User stories

- **U1 — Contributor:** clone `gbv`, configure the supported Veyr toolchain and legal fixtures, and reproduce checks without cloning Veyr.
- **U2 — Test author:** run bounded deterministic tests and receive actionable failure evidence.
- **U3 — ROM owner:** inspect and load a legally supplied ROM Image with clear validation errors.
- **U4 — DMG player:** play supported DMG software with correct video and input.
- **U5 — Persistent player:** retain Save Data and RTC behavior safely across sessions.
- **U6 — CGB player:** play native CGB and DMG-compatible software accurately.
- **U7 — Desktop player:** use stable real-time video, input, audio, pacing, and shutdown.
- **U8 — Investigator:** trace, inspect, stop, Snapshot, and replay the Machine deterministically.
- **U9 — Maintainer:** publish evidence-backed, reproducible open-source releases.

## v0.0.1 — scientific foundation

1. **F01 — Bootstrap the Veyr project and gate the repository**
   - Blocked by: none.
   - Covers: U1, U9.
   - Complete when a clean checkout obtains an exact-version, SHA-256-pinned Veyr toolchain outside the Veyr repository, exposes `veyr` and `veyrc` in the Nix development shell, builds and runs the `gbv` bootstrap executable, and passes the required formatting, shell, build, and smoke checks.

2. **F02 — Execute a self-owned serial-pass ROM through the deterministic Machine**
   - Blocked by: F03.
   - Covers: U2, U3.
   - Complete when loader, scheduler, minimal Bus/SM83/serial path, bounded CLI, and a project-owned ROM produce an exact PASS outcome twice.

3. **F03 — Select and specify the first DMG and CGB Hardware Profiles**
   - Blocked by: F01.
   - Covers: U2, U4, U6.
   - Complete when CGB-D and one evidence-backed DMG revision have explicit modes, startup behavior, Boot Policy configurations, and test applicability without a generic-profile fallback.

4. **F04 — Pin and run public Conformance ROMs reproducibly**
   - Blocked by: F02.
   - Covers: U1, U2, U9.
   - Complete when a project-owned shell/CLI harness validates manifest, source, license, hash, profile, budget, and completion protocol and runs one permitted external ROM without depending on Veyr's deferred process-test contract.

5. **F05 — Emit deterministic traces and canonical Machine-state hashes**
   - Blocked by: F02.
   - Covers: U2, U8.
   - Complete when a versioned trace and state-hash contract fixes field order, integer encoding, hash algorithm, exclusions, and bounds; identical inputs then produce byte-identical records while one controlled input change produces a located divergence.

## v0.0.2 — headless SM83

6. **C01 — Run SM83 load/store families with exact bus traces**
   - Blocked by: F05.
   - Covers: U2.
   - Complete when register, immediate, indirect, high-memory, increment/decrement, and 16-bit load families match exact values, phases, and bus addresses.

7. **C02 — Run arithmetic and flag families against exhaustive local oracles**
   - Blocked by: F05.
   - Covers: U2.
   - Complete when add/subtract/carry, logical, compare, increment/decrement, `DAA`, complements, carry operations, and signed `SP+e8` pass exhaustive flag/value checks and a ROM tracer.

8. **C03 — Run branch, call, return, restart, and stack families with timing evidence**
   - Blocked by: C01.
   - Covers: U2, U8.
   - Complete when taken/untaken paths, stack order, target addresses, and bus phases pass focused ROM and trace gates.

9. **C04 — Run all CB rotate, shift, swap, bit, reset, and set operations**
   - Blocked by: C02.
   - Covers: U2.
   - Complete when all 256 CB-prefixed encodings are classified and pass value/flag/phase tests for register and `(HL)` forms.

10. **C05 — Pass interrupt entry, delayed `EI`, HALT, STOP, and CPU hard-lock probes**
   - Blocked by: C03.
    - Covers: U2, U8.
    - Complete when interrupt priority/entry, wake behavior, HALT bug, ordinary STOP behavior, and all invalid opcodes match focused required outcomes.

11. **C06 — Gate the complete SM83 surface with the pinned CPU matrix**
   - Blocked by: F04, C04, C05.
    - Covers: U1, U2, U9.
    - Complete when every base/CB opcode is accounted for and CPU-only Mooneye/Blargg semantics probes have no unexplained required result; platform-dependent timing suites remain owned by later device slices.

## v0.0.3 — accurate DMG platform and video

12. **D01 — Execute DMG address routing, IF/IE, and serial register-shell traces**
   - Blocked by: C06.
    - Covers: U2, U4.
   - Complete when WRAM, HRAM, VRAM, OAM, I/O, unusable regions, IF/IE priority, and serial completion route through the Bus with exact boundary behavior, and registers owned by later device slices have explicit documented shell behavior rather than accidental storage.

13. **D02 — Pass divider and timer edge/reload-window Conformance ROMs**
    - Blocked by: D01.
    - Covers: U2, U4.
    - Complete when DIV/TAC falling edges, write glitches, TIMA overflow/reload windows, TMA writes, and timer interrupts pass local and public gates.

14. **D03 — Pass live OAM DMA transfer and restart probes**
    - Blocked by: D01.
    - Covers: U2, U4.
    - Complete when byte phases, source routing, CPU HRAM-only behavior, restart, and recent-bus evidence match the initial DMG profile without treating DMA as an instant copy.

15. **D04 — Produce the first exact dot-stepped DMG background/window Frame**
   - Blocked by: D01.
    - Covers: U2, U4.
    - Complete when LCD/LY/STAT, tile fetching, Pixel FIFO, SCX discard, window start/counter, and exact Frame hashing work through a project-owned ROM.

16. **D05 — Pass DMG object selection, fetch, priority, and `dmg-acid2`**
    - Blocked by: D03, D04.
    - Covers: U2, U4.
    - Complete when the ten-object limit, sprite stalls, DMG priority, clipping, and exact Acid2 framebuffer pass.

17. **D06 — Pass PPU access-lock and DMG OAM-corruption probes**
   - Blocked by: D05.
    - Covers: U2, U4.
    - Complete when mode-dependent VRAM/OAM access, DMA conflicts, and supported revision-specific OAM corruption match selected public probes.

18. **D07 — Pass selected DMG mid-scanline and LCD-transition gates**
   - Blocked by: D06.
    - Covers: U2, U4, U9.
    - Complete when selected Mealybug and relevant Mooneye PPU results are exact for the initial DMG profile.

19. **D08 — Replay deterministic joypad input to exact Frame and state outcomes**
   - Blocked by: D04, F05.
    - Covers: U2, U4, U8.
    - Complete when matrix selection, interrupts, STOP wake, timestamped complete button states, and replay hashes pass end to end.

## v0.0.4 — robust DMG cartridges and audio

20. **K01 — Run ROM-only homebrew through validated cartridge capabilities**
   - Blocked by: D01.
    - Covers: U3, U4.
    - Complete when header controller/capability parsing, image/RAM validation, ROM-only routing, diagnostics, and a public homebrew smoke pass.

21. **K02 — Run MBC1/MBC1M software with crash-safe Save Data**
   - Blocked by: K01.
    - Covers: U3, U4, U5.
    - Complete when MBC1 banking, forbidden aliases, structural MBC1M detection or explicit override, Persistence Record validation, and interrupted-write recovery pass.

22. **K03 — Pass MBC2 controller and four-bit RAM persistence probes**
    - Blocked by: K01.
    - Covers: U3, U4, U5.
   - Complete when address-bit selection, bank aliases, nibble RAM, enable gates, and the controller-specific payload in the shared Persistence Record pass exact matrices.

23. **K04 — Pass MBC5 high-bank, RAM-bank, and rumble-state probes**
   - Blocked by: K02.
    - Covers: U3, U4, U5.
   - Complete when nine-bit ROM banks including bank zero, RAM banks, enable gates, capability flags, the controller-specific Persistence Record payload, and observable rumble state pass exact matrices.

24. **K05 — Pass MBC3/MBC30 timer capability, RTC, and persistence probes**
   - Blocked by: K02.
    - Covers: U3, U5, U6.
   - Complete when timerless/timer-capable headers, latch edges, halt, carry, day overflow, MBC30 RAM, deterministic elapsed-time injection, and the RTC payload/host timestamp metadata in the shared Persistence Record pass local and public gates.

25. **A01 — Produce the first deterministic audible pulse-channel path**
   - Blocked by: D02.
    - Covers: U2, U7.
    - Complete when DIV-APU sequencing, pulse channel 1, sweep/length/envelope, mixing, and an exact caller-selected sample stream work end to end.

26. **A02 — Complete deterministic DMG channels, mixing, filtering, and resampling**
    - Blocked by: A01.
    - Covers: U2, U7.
    - Complete when pulse 2, wave/Wave RAM, noise/LFSR, NR50/NR51, high-pass filtering, and fixed-point resampling produce exact fixtures without host-time input.

27. **A03 — Gate the complete DMG APU with the pinned sound matrix**
   - Blocked by: A02.
    - Covers: U1, U2, U9.
    - Complete when applicable Blargg/SameSuite sound tests, exact sample counts, and determinism gates have no unexplained required result.

## v0.0.5 — playable CGB

28. **G01 — Boot CGB-D and render a banked VRAM/WRAM/palette Frame**
   - Blocked by: D05.
    - Covers: U2, U6.
    - Complete when CGB Mode, WRAM/VRAM banks, BGR555 palette RAM, tile attributes, and a project-owned native-CGB ROM produce an exact Frame.

29. **G02 — Pass CGB priority behavior and `cgb-acid2`**
    - Blocked by: G01.
    - Covers: U2, U6.
    - Complete when CGB background/object priority, attributes, palette access, and exact Acid2 output pass.

30. **G03 — Pass CGB speed-switch transient and OAM DMA conflict probes**
   - Blocked by: D02, G01.
    - Covers: U2, U6.
    - Complete when KEY1/STOP, CPU/DIV pause, steady-state split CPU/PPU cadence, mode effects, and CGB OAM DMA bus conflicts match selected profile tests.

31. **G04 — Pass GDMA and HDMA start, transfer, cancellation, and LCD-mode probes**
   - Blocked by: G03.
    - Covers: U2, U6.
    - Complete when General/HBlank DMA byte phases, source/destination masks, cancellation, LCD-off, and double-speed behavior pass exact gates.

32. **G05 — Pass CGB DMG Compatibility Mode and boot-palette gates**
    - Blocked by: D07, D08, G01.
    - Covers: U2, U4, U6.
    - Complete when DMG software executes on physical CGB-D with documented BGR555 compatibility palettes, Boot Policy behavior, and profile-specific state/Frame results.

33. **G06 — Implement and gate CGB timing, DMA, PPU, and APU behavior**
   - Blocked by: A03, G02, G04, G05.
    - Covers: U1, U2, U6, U7, U9.
   - Complete when CGB-specific APU register, Wave RAM, channel, and speed-switch behavior is implemented and the pinned CGB Mooneye, Mealybug, SameSuite, speed, DMA, audio, and deterministic sample matrix has no unexplained required result.

## v0.0.6 — desktop beta

34. **H01 — Play DMG public homebrew through the raylib video/input Frontend**
    - Blocked by: D05, D08, K02.
    - Covers: U4, U7.
    - Complete when the host adapter presents 160×144 Frames, maps keyboard/gamepad input, scales cleanly, and exits without changing headless Machine results. Completed Veyr issues DEV-343 and DEV-344 supply the media facade.

35. **H02 — Add real-time raylib audio and accuracy-preserving pacing**
    - Blocked by: A03, H01.
    - Covers: U4, U7.
    - Complete when PCM output, buffer-driven pacing, fast-forward equivalence, volume, underrun/overrun stress evidence, and clean shutdown operate without Machine-time drift. If the shipped push contract fails the measured quality gate, reuse DEV-504 under DEV-503 for callback-backed audio and link it then.

36. **H03 — Ship the ROM, configuration, and Persistence Record lifecycle**
    - Blocked by: H01, K02, K03, K04, K05.
    - Covers: U3, U5, U7.
    - Complete when supported controllers load/save through predictable paths, optional Boot ROM and profile configuration are clear, dirty generations flush atomically, corruption is diagnosed, and process restart restores exact Save Data/RTC progression.

37. **H04 — Run all declared Pokémon DMG/CGB compatibility milestones privately**
   - Blocked by: G06, H02, H03.
    - Covers: U4, U5, U6, U7, U9.
   - Complete when legally owned Red, Blue, Yellow, Gold, Silver, and Crystal revisions pass documented pre-Snapshot boot/play/battle/save/reload/RTC/native-CGB checkpoints with no proprietary public artifacts or game-specific branches.

## v0.0.7 — compatibility beta

38. **Q01 — Round-trip complete versioned Snapshots and deterministic input replay**
   - Blocked by: D08, K03, K04, K05, G06.
    - Covers: U2, U5, U8.
    - Complete when CPU, timer, PPU FIFO, DMA, APU/resampler, every supported controller, RTC, serial, input, and scheduler in-flight state restore at hostile boundaries and reproduce later hashes.

39. **Q02 — Ship deterministic register, memory, device, breakpoint, and watchpoint inspection**
   - Blocked by: F05, G06, H03.
    - Covers: U2, U8.
    - Complete when the headless CLI can inspect CPU/Bus/PPU/APU/DMA/Cartridge state, stop on deterministic conditions, and emit bounded reproduction artifacts.

40. **Q03 — Publish the compatibility beta with exhaustive evidence**
   - Blocked by: H04, Q01, Q02.
    - Covers: U1, U2, U8, U9.
   - Complete when the full pinned matrix, private Pokémon Snapshot rerun, long replay, Save Data durability, versioned performance budget, fixture/license audit, and generated compatibility report have no unexplained result.

## v0.1.0 — stable release

41. **R01 — Publish the token-free reproducible Linux v0.1.0 release**
    - Blocked by: Q03, DEV-314, DEV-317.
    - Covers: U1 through U9.
    - Complete when a token-free public Veyr install path, stable Machine facade, source/binary artifacts, checksums, provenance, exact Veyr/Nix pins, security/contributor docs, and clean-machine smoke all pass.

## Cross-project dependencies

- No open Veyr issue blocks F01 or the Linux Machine implementation.
- DEV-343 and DEV-344 are complete and prove the raylib framebuffer/input/PCM slice used by H01/H02; DEV-503's full API epic is not a blocker.
- DEV-314 and DEV-317 block only R01's stranger-facing, token-free release acceptance. They do not block local development.
- DEV-504 becomes a blocker for H02 only if measured push-audio stress evidence proves callback-backed audio is required.
- A newly discovered compiler defect receives a standalone reducer and upstream conformance/golden acceptance. An existing upstream owner may be reused directly once its documented acceptance is demonstrably required.

## Proposed Linear structure

- One umbrella issue: `Story: ship the accuracy-oriented DMG+CGB emulator`.
- Eight Linear milestones matching the roadmap releases.
- The 41 slices above as children of the umbrella, assigned to their milestone.
- Labels: `gbv:foundation`, `gbv:cpu`, `gbv:ppu`, `gbv:apu`, `gbv:cartridge`, `gbv:devices`, `gbv:cgb`, `gbv:frontend`, `gbv:delivery`, and `gbv:accuracy`.
- Apply the existing `ready-for-agent` label only when all blockers are complete, the issue is independently implementable, and any required private acceptance input is available. H04 is a maintainer acceptance issue, not an AFK-agent issue.
