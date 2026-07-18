# Cartridges and RTC

The Cartridge is hardware, not merely a ROM Image. It owns controller state, optional RAM, optional RTC state, and any supported cartridge device behavior.

## Header authority

The ROM Image header determines declared CGB support, controller type, image size, RAM size, and header checksums. `gbv` validates these fields against actual bytes and rejects impossible or unsupported combinations with typed diagnostics.

Game titles and ROM hashes never select a Cartridge Controller. Compatibility planning may name games, but runtime behavior follows header metadata, documented structural detection, explicit configuration where unavoidable, and the selected Hardware Profile.

## Stable controller scope

- ROM-only;
- MBC1, with MBC1M selected only by documented structural detection or explicit override because the header does not identify it;
- MBC2 with its address-bit selection and four-bit RAM behavior;
- MBC3 with independent RAM, battery, and timer capabilities; only timer-capable header types expose RTC registers;
- MBC30 when the supported MBC3 extension and 64 KiB RAM combination is proven;
- MBC5, including observable rumble state where applicable.

Controller-specific bank aliases, masks, enable gates, and inaccessible ranges are tested as explicit matrices. Unsupported controllers fail clearly rather than degrading to ROM-only behavior.

## RTC boundary

The core never reads system time. It receives explicit elapsed-time synchronization under one of three host policies:

- fixed/manual time for unit and Conformance ROM tests;
- emulated time for deterministic replay;
- wall-clock persistence for ordinary play.

Timer-capable MBC3 state includes live and latched time registers, the previous latch command, halt and day-carry state, selected RTC register, and deterministic fractional progression. The controller implements the 0-to-1 latch transition and the hardware day-counter behavior.

Time zones and calendar rules are irrelevant to the emulated hardware. A host reference timestamp exists only in Persistence Record metadata. The host computes nonnegative elapsed duration according to a documented backward-clock policy and passes that duration to the Machine.

## Persistence

Battery RAM and RTC persistence are separate from Snapshots. The host associates them with a strong ROM identity and writes them using temporary-file plus atomic-replace semantics where the platform supports it.

The [Pan Docs cartridge header](https://gbdev.io/pandocs/The_Cartridge_Header.html) and [MBC3 documentation](https://gbdev.io/pandocs/MBC3.html) are the initial public references; hardware-derived controller and RTC tests take precedence where behavior differs.
