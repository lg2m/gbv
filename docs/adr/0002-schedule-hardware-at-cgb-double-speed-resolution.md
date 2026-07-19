# Schedule hardware at CGB double-speed resolution

`gbv` uses a monotonically increasing 8,388,608 Hz Sub-tick timeline. Normal-speed CPU T-cycles and PPU Dots consume two Sub-ticks; a CGB double-speed CPU T-cycle consumes one while the PPU retains its cadence. CPU instructions advance through bus-visible operations rather than one atomic mutation followed by a duration adjustment, accepting greater initial implementation cost to avoid later timing rewrites for interrupts, timers, DMA, speed switching, and the PPU.
