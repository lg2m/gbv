# Clocking and scheduling

`gbv` uses one deterministic master timeline measured in Sub-ticks at 8,388,608 Hz. This is the finest globally scheduled interval required by the supported hardware: one CGB double-speed CPU T-cycle.

## Clock domains

The table describes steady-state clock ratios. CGB speed switching itself is a hardware transition with CPU/DIV pause and mode-dependent access behavior that receives separate tests.

| Domain | Normal speed | CGB double speed |
|---|---:|---:|
| Master timeline | 1 Sub-tick | 1 Sub-tick |
| CPU T-cycle | 2 Sub-ticks | 1 Sub-tick |
| PPU Dot | 2 Sub-ticks | 2 Sub-ticks |

A display Frame remains 154 lines of 456 PPU Dots. CPU speed switching never changes the PPU frame cadence.

The APU, timer, DMA, serial, and cartridge devices derive their transitions from the relevant hardware clock or divider edge. They do not use host elapsed time.

## CPU execution

An instruction is a sequence of bus-visible operations. Each operation may fetch an opcode or operand, read or write the bus, update registers, change the program counter or stack pointer, or perform interrupt arbitration.

Two instructions with the same total duration may expose different addresses and side effects at different times. Treating instructions as atomic would prevent the bus, DMA, timer, and PPU from observing those differences.

## Scheduling contract

The Machine owns the master timestamp and advances devices in a deterministic order defined by the hardware model. A run budget is expressed in Sub-ticks or in an event boundary such as a completed Frame, audio watermark, test breakpoint, debug stop, or CPU hard-lock.

Host pacing is never an input to emulated timing. Fast-forward removes host waiting; it does not change the sequence of Machine transitions.

## Verification

Clock-domain tests must cover:

- normal-speed and CGB double-speed CPU progression;
- invariant steady-state PPU cadence plus the documented speed-switch transient;
- divider and timer edge behavior;
- interrupt entry and delayed interrupt enable;
- OAM DMA, GDMA, and HDMA bus phases;
- audio sample counts independent of host frame rate;
- identical state hashes for identical initial state, input, and Sub-tick budget.

Primary references are the [Pan Docs hardware specifications](https://gbdev.io/pandocs/Specifications.html), [timer behavior](https://gbdev.io/pandocs/Timer_Obscure_Behaviour.html), [HALT behavior](https://gbdev.io/pandocs/halt.html), and [OAM DMA behavior](https://gbdev.io/pandocs/OAM_DMA_Transfer.html).
