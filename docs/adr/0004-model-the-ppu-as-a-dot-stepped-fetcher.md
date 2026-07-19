# Model the PPU as a dot-stepped fetcher

`gbv` models OAM scanning, background/window and object fetching, Pixel FIFOs, stalls, priority, and output one PPU Dot at a time instead of rendering each scanline atomically. This increases the cost of the first visible frame but preserves variable Mode 3 timing, mid-scanline effects, bus restrictions, and revision-specific behavior required by the project's accuracy promise without a later PPU rewrite.
