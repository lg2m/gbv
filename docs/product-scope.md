# Product scope

`gbv` is a general, accuracy-oriented Game Boy and Game Boy Color emulator written from scratch in Veyr. Pokémon titles are concrete compatibility milestones, not game-specific scope boundaries or sources of hardware behavior.

## Stable-release promise

The first stable release targets:

- DMG hardware and CGB hardware in both CGB Mode and DMG Compatibility Mode;
- explicit, documented Hardware Profiles rather than an unspecified generic console;
- deterministic headless execution with video, input, four-channel audio, Save Data, Snapshots, tracing, and debugging;
- ROM-only, MBC1/MBC1M, MBC2, MBC3/MBC30 with RTC, and MBC5 cartridges;
- optional user-supplied Boot ROMs and a documented Post-boot Start;
- a Linux x86-64 desktop Frontend using Veyr's supported raylib package;
- public hardware-derived conformance suites and locally owned commercial-title compatibility checks.

The emulator must not special-case a title or ROM hash to compensate for inaccurate hardware behavior.

## Compatibility milestones

- Pokémon Red and Blue prove the first DMG play/save/reload path.
- Pokémon Yellow broadens cartridge and presentation coverage.
- Pokémon Gold and Silver prove MBC3 RTC behavior and DMG/CGB compatibility.
- Pokémon Crystal proves the native CGB play/save/RTC path.

Commercial ROMs, Boot ROMs, extracted assets, screenshots, save files, and ROM-derived fixtures are never committed or required by public CI.

## Deferred beyond the stable core

- Super Game Boy enhancements;
- link cable, trading, netplay, and network transport;
- Game Boy Printer, Camera, infrared, tilt, and other accessories;
- obscure or unlicensed cartridge controllers;
- shader filters, achievements, cheat systems, and library browsing;
- host platforms not yet supported by Veyr.
