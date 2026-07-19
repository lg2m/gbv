# PPU architecture

`gbv`'s PPU is a hardware state machine advanced one Dot at a time. It produces hardware-oriented pixels inside the deterministic Machine; the Frontend alone converts those pixels for the host display.

## Pipeline

The implementation models:

1. Mode 2 OAM scanning and selection of at most ten objects for the line;
2. background/window tile and attribute fetching;
3. a background/window Pixel FIFO;
4. object fetching, stalls, and an object Pixel FIFO;
5. DMG or CGB priority resolution;
6. pixel output after `SCX` discard and window transitions;
7. HBlank, VBlank, STAT-line edges, and LCD enable/disable transitions.

Mode 3 duration is an outcome of fetch progress and stalls rather than a fixed constant. CPU access to VRAM and OAM is decided by the bus using current PPU and DMA state.

## Pixel representation

- Physical DMG output is a shade index from 0 through 3.
- Physical CGB output, including DMG Compatibility Mode, is a 15-bit BGR value with red in bits 0–4, green in bits 5–9, and blue in bits 10–14.
- The Frontend converts a completed 160×144 Frame into RGBA8 for `vendor.raylib`.

Keeping host pixels outside the Machine makes frame hashes independent of presentation color correction, scaling, and window behavior.

## Accuracy gates

Implementation proceeds through increasingly strong evidence:

1. project-owned micro-ROMs for tile, window, object, and priority behavior;
2. exact `dmg-acid2` and `cgb-acid2` framebuffer results;
3. relevant Mooneye PPU and access tests;
4. selected Mealybug Tearoom mid-scanline timing images for each Hardware Profile;
5. locally owned commercial-title Compatibility Reports.

Acid2 is a structural intermediate gate, not proof of complete Mode 3 timing.

Primary references are [Pan Docs rendering](https://gbdev.io/pandocs/Rendering.html), the [Pixel FIFO description](https://gbdev.io/pandocs/pixel_fifo.html), [dmg-acid2](https://github.com/mattcurrie/dmg-acid2), [cgb-acid2](https://github.com/mattcurrie/cgb-acid2), and the [Mealybug Tearoom tests](https://github.com/mattcurrie/mealybug-tearoom-tests).
