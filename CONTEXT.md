# gbv

`gbv` is an accuracy-oriented emulator for the Game Boy hardware families. This glossary defines the project language used by architecture, tests, issues, and code.

**gbv**:
The lowercase proper name of this project and its command-line program.
_Avoid_: Uppercase spellings

## Hardware and execution

**Machine**:
One emulated console instance, including its processor, memory, devices, and inserted Cartridge.
_Avoid_: Emulator instance, console object

**Hardware Profile**:
The precise hardware model, operating mode, and revision whose observable behavior a Machine reproduces.
_Avoid_: Color flag, generic Game Boy

**Boot Policy**:
Run configuration selecting a user-supplied Boot ROM or a documented Post-boot Start independently of the Hardware Profile.
_Avoid_: Hardware revision

**DMG**:
The original monochrome Game Boy hardware family.
_Avoid_: Classic mode, black-and-white mode

**CGB**:
The Game Boy Color hardware family, capable of CGB Mode or DMG Compatibility Mode.
_Avoid_: GBC hardware

**CGB Mode**:
Color operation selected for a cartridge that enables CGB features.
_Avoid_: Color mode

**DMG Compatibility Mode**:
CGB hardware operating with monochrome-cartridge behavior.
_Avoid_: Game Boy mode

**Dot**:
One PPU display-clock interval.
_Avoid_: Pixel cycle

**Sub-tick**:
The smallest interval on the Machine's master hardware timeline.
_Avoid_: Half-dot, host tick

**CPU T-cycle**:
One processor clock interval: two Sub-ticks at normal speed and one Sub-tick at CGB double speed.
_Avoid_: Cycle when the CPU or PPU domain is ambiguous

**Frame**:
One completed 154-line display scan sequence produced by the Machine, independent of host presentation.
_Avoid_: Frontend refresh

**PPU**:
The pixel processing unit that scans display state, fetches background/window/object data, arbitrates video-memory access, and produces Frames.
_Avoid_: GPU, renderer

**Pixel FIFO**:
A hardware-modeled queue through which fetched background/window and object pixels are combined before display output.
_Avoid_: Scanline buffer

**SM83**:
The Game Boy processor instruction set and execution unit modeled by the Machine.
_Avoid_: Z80, LR35902 when naming the instruction set

**Bus**:
The Machine component that arbitrates CPU-visible addresses, devices, banking, access restrictions, DMA conflicts, tracing, and watchpoints.
_Avoid_: Memory array

**APU**:
The audio processing unit that advances hardware audio channels and produces deterministic samples.
_Avoid_: Audio device, sound backend

**DMA**:
A live hardware transfer that arbitrates buses over time, including OAM DMA, GDMA, and HDMA.
_Avoid_: Memory copy

## Cartridge and persistence

**ROM Image**:
Immutable cartridge program bytes supplied to a Machine.
_Avoid_: ROM when referring to the complete cartridge

**Cartridge**:
A ROM Image together with its controller, optional RAM, real-time clock, and other cartridge hardware.
_Avoid_: ROM

**Cartridge Controller**:
Cartridge address-decoding and bank-switching hardware, commonly called a memory bank controller.
_Avoid_: Mapper when referring to the complete Cartridge

**Save Data**:
Cartridge-backed persistent RAM and deterministic RTC hardware state retained between sessions.
_Avoid_: Save state

**RTC**:
The cartridge real-time clock whose deterministic registers and progression are part of Save Data.
_Avoid_: Host clock, calendar

**Persistence Record**:
A host-owned file envelope containing Save Data, ROM identity, format metadata, and any wall-clock synchronization metadata that is not Machine state.
_Avoid_: Snapshot

**Snapshot**:
An emulator-defined capture of the complete Machine state used for restore, replay, or debugging.
_Avoid_: Save Data, battery save

**Boot ROM**:
Console firmware optionally mapped during power-on, distinct from the cartridge ROM Image.
_Avoid_: BIOS

**Post-boot Start**:
A clean-room initialized Machine state beginning after firmware execution.
_Avoid_: Skip boot

## Evidence and host integration

**Conformance ROM**:
A redistributable program with a documented hardware-derived pass oracle.
_Avoid_: Test game

**Compatibility Report**:
An observation about one title, `gbv` version, Hardware Profile, and configuration; it is not proof of general conformance.
_Avoid_: Compatibility claim

**Frontend**:
Host-facing presentation and persistence code that supplies input and consumes video, audio, and Save Data without defining hardware behavior.
_Avoid_: Emulator core
