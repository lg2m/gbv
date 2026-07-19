# References

Non-obvious hardware behavior should cite the strongest available source near the relevant code or test.

## Hardware references

- [Game Boy: Complete Technical Reference](https://gekkio.fi/files/gb-docs/gbctr.pdf)
- [Pan Docs](https://gbdev.io/pandocs/)
- [Pan Docs power-up and boot handoff](https://gbdev.io/pandocs/Power_Up_Sequence.html)
- [Pan Docs cartridge CGB flag](https://gbdev.io/pandocs/The_Cartridge_Header.html#0143--cgb-flag)
- [RGBDS SM83 instruction reference](https://rgbds.gbdev.io/docs/v0.9.4/gbz80.7)
- [gb-opcodes structured opcode data](https://gbdev.io/gb-opcodes/Opcodes.json)
- [Game Boy hardware database](https://gbhwdb.gekkio.fi/)
- [DMG-C reference unit GM6058180](https://gbhwdb.gekkio.fi/consoles/dmg/GM6058180.html)
- [CGB-D reference unit CH20983903](https://gbhwdb.gekkio.fi/consoles/cgb/CH20983903.html)

## Public test suites

- [Mooneye Test Suite](https://github.com/Gekkio/mooneye-test-suite)
- [Blargg Game Boy test ROM mirror](https://github.com/retrio/gb-test-roms)
- [dmg-acid2](https://github.com/mattcurrie/dmg-acid2)
- [cgb-acid2](https://github.com/mattcurrie/cgb-acid2)
- [Mealybug Tearoom tests](https://github.com/mattcurrie/mealybug-tearoom-tests)
- [SameSuite](https://github.com/LIJI32/SameSuite)
- [rtc3test](https://github.com/aaaaaa123456789/rtc3test)

## Differential investigation

- [SameBoy](https://github.com/LIJI32/SameBoy)

Mature-emulator behavior is not a final oracle. Differential comparisons identify disagreements that must be resolved through hardware evidence or hardware-derived tests.
