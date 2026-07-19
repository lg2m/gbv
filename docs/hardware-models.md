# Hardware models

`gbv` models named real hardware rather than combining behavior from several
revisions into a fictional generic Game Boy. A run that omits a profile, names
an unknown profile, or requests an impossible profile/mode/cartridge combination
is rejected.

## Hardware Profile contract

A Hardware Profile contains exactly three pieces of hardware identity:

- physical model family;
- SoC revision;
- operating mode.

Startup state, Boot ROM bytes, Save Data, input, RTC state, and other run inputs
are selected by separate contracts. CPU speed is runtime Machine state because
CGB software may switch between normal and double speed.

The initial stable profile IDs are:

| Stable ID | Model | SoC revision | Operating mode |
|---|---|---|---|
| `dmg-c/dmg` | DMG-01 | `DMG-CPU C` | DMG |
| `cgb-d/cgb` | CGB-001 | `CPU CGB D` | native CGB |
| `cgb-d/dmg-compat` | CGB-001 | `CPU CGB D` | DMG Compatibility Mode |

There is no `default`, `auto`, `generic`, or `is_color` alias. Stable IDs are
recorded by tests, traces, failure artifacts, and Compatibility Reports.

## Selected physical references

The behavioral revision is the CPU/SoC revision. Board identity is retained as
evidence provenance, not used as the profile name: the same board revision can
contain different SoC revisions.

| Profile | Hardware-derived reference | Physical provenance | Selection reason |
|---|---|---|---|
| DMG-C | Mooneye hardware unit [`GM6058180`](https://gbhwdb.gekkio.fi/consoles/dmg/GM6058180.html) | DMG-01, `DMG-CPU C`, reference board `DMG-CPU-06` | Mooneye manually verifies its tests on this exact DMG-C unit. |
| CGB-D | Mooneye hardware unit [`CH20983903`](https://gbhwdb.gekkio.fi/consoles/cgb/CH20983903.html) | CGB-001, `CPU CGB D`, reference board `CGB-CPU-05` | Mooneye's hardware fleet directly includes CGB-D. |

The [Mooneye hardware-testing inventory](https://github.com/Gekkio/mooneye-test-suite#hardware-testing)
distinguishes DMG revisions 0/A/B/C and CGB revisions 0/A/B/C/D/E. It treats
the SoC revision as the deterministic behavior boundary unless hardware evidence
shows a board- or unit-dependent difference. That claim excludes analog traits
such as audio filtering and LCD response; future analog-accuracy claims require
their own reference chain.

## Cartridge and mode compatibility

Header byte `0x0143` is normalized into three project values. A clear bit 7 is
DMG software, the usual `0x80` value is CGB-enhanced but DMG-compatible
software, and `0xC0` declares CGB-only software. Real CGB hardware ignores bit
6 when selecting CPU mode, but `gbv` preserves the declared compatibility so a
CGB-only image is rejected on DMG hardware. See the [Pan Docs CGB flag
definition](https://gbdev.io/pandocs/The_Cartridge_Header.html#0143--cgb-flag).

| Requested profile | DMG software | CGB-compatible software | CGB-only software |
|---|---:|---:|---:|
| `dmg-c/dmg` | accept | accept | reject |
| `cgb-d/cgb` | reject | accept | accept |
| `cgb-d/dmg-compat` | accept | reject | reject |

A dual-mode image runs on DMG-C because it is backward compatible, but on a
CGB its set bit 7 selects native CGB mode. The official CGB boot path does not
offer a user-selectable way to force that image into DMG Compatibility Mode.
The header constrains operating mode; it never changes the selected physical
revision. Titles and ROM hashes never select hardware behavior.

## Boot Policy

Boot Policy is separate run configuration. Every initial Hardware Profile
supports both policies, but a conformance oracle applies only when its manifest
names the same policy and policy inputs.

### User Boot ROM (`boot-rom`)

This policy starts at `PC=0x0000` with user-supplied Boot ROM bytes mapped. The
repository never contains or downloads Nintendo firmware. A run must record the
file representation and SHA-256 digest; changing the bytes changes the run
identity even when the friendly policy name is unchanged.

- DMG-C accepts the 256-byte DMG address space mapped at `0x0000-0x00ff`.
- CGB-D accepts the common 2304-byte address-shaped representation. Hardware
  maps only `0x0000-0x00ff` and `0x0200-0x08ff`; `0x0100-0x01ff` remains visible
  from the cartridge and is not Boot ROM storage.
- The Boot ROM remains mapped until emulated code disables it through `0xff50`,
  then hands execution to cartridge address `0x0100`.

These mappings and entry points come from the [Pan Docs power-up
sequence](https://gbdev.io/pandocs/Power_Up_Sequence.html) and [Game Boy:
Complete Technical Reference](https://gekkio.fi/files/gb-docs/gbctr.pdf).

### Post-boot Start (`post-boot-start`)

This is a clean-room, deterministic cartridge-handoff state, not raw power-on.
The Boot ROM is disabled, `PC=0x0100`, and `SP=0xfffe`. The CPU register contract
is derived from the selected profile and explicit cartridge-header inputs:

| Profile | CPU registers at handoff |
|---|---|
| `dmg-c/dmg` | `A=01 B=00 C=13 D=00 E=d8 H=01 L=4d`; `F=80` when header checksum byte `0x014d` is zero, otherwise `F=b0` |
| `cgb-d/cgb` | `AF=1180 BC=0000 DE=ff56 HL=000d` |
| `cgb-d/dmg-compat` | `A=11 F=80 C=00 DE=0008`; `B` is the 16-byte title sum for Nintendo-licensee headers, otherwise `00`; `HL=991a` when `B` is `43` or `58`, otherwise `007c` |

The values and derivations are documented in the [Pan Docs handoff
table](https://gbdev.io/pandocs/Power_Up_Sequence.html#console-state-after-boot-rom-hand-off)
and checked by its linked Mooneye boot-register tests.

The initial deterministic CGB compatibility input convention is **no buttons
held** during the logo animation. Compatibility palettes, timing-sensitive I/O,
and some handoff state depend on the cartridge header and boot input; they must
be derived from those recorded inputs rather than replaced with one universal
snapshot. Device-register initialization follows the applicable Pan Docs
handoff table and Mooneye `boot_hwio` oracle. Values documented as unknown,
timing-dependent, or uninitialized remain explicit rather than guessed.

WRAM and HRAM are random on physical power-up and depend on temperature and
prior state. F03 does not claim fixed hardware bytes for them. A deterministic
headless fixture must explicitly choose and record a project-owned
initialization policy. A raw-power-on randomness oracle is outside Post-boot
Start by policy; for a Boot ROM run, a missing memory-initialization input is a
missing capability and must never be hidden as `not-applicable`.

## Conformance applicability

F03 records the applicability rule and expected result. F04 owns the manifest
that pins an exact upstream revision, license, artifact digest, Boot Policy,
fetch/build procedure, budget, and runner.

| Public oracle | `dmg-c/dmg` | `cgb-d/cgb` | `cgb-d/dmg-compat` | Expected result |
|---|---:|---:|---:|---|
| Mooneye [`boot_regs-dmgABC`](https://github.com/Gekkio/mooneye-test-suite/blob/main/acceptance/boot_regs-dmgABC.s) | required | not-applicable | not-applicable | Mooneye pass-register/serial protocol |
| Mooneye [`boot_hwio-dmgABCmgb`](https://github.com/Gekkio/mooneye-test-suite/blob/main/acceptance/boot_hwio-dmgABCmgb.s) | required | not-applicable | not-applicable | Mooneye pass-register/serial protocol |
| Mooneye tests whose source pass list includes CGB-D/CGB | not-applicable | required when the ROM selects CGB mode | required only when the source explicitly selects CGB compatibility | Mooneye pass-register/serial protocol |
| [`dmg-acid2`](https://github.com/mattcurrie/dmg-acid2) | required | not-applicable | required | exact DMG or CGB-in-DMG-mode reference image, respectively |
| [`cgb-acid2`](https://github.com/mattcurrie/cgb-acid2) | not-applicable | required | not-applicable | exact CGB reference image |
| Tests explicitly limited to DMG0, MGB, SGB, AGB, or another excluded revision | not-applicable | not-applicable | not-applicable unless the upstream source explicitly includes CGB compatibility | source-defined oracle |

Mooneye's source-level pass/fail hardware list is authoritative; a filename
suffix is only a routing hint. `cgb-acid2` is a CGB-mode image oracle but does
not identify a CGB SoC revision, so Mooneye's hardware fleet—not Acid2—is the
evidence for choosing CGB-D.

Applicability dispositions mean:

- `required`: the upstream oracle covers the exact hardware, mode, and Boot
  Policy; the expected result must pass;
- `known-fail`: the oracle applies, `gbv` disagrees, and an open linked issue
  owns the captured failure;
- `not-applicable`: the upstream oracle excludes the hardware, mode, or Boot
  Policy, with the reason retained.

`not-applicable` never hides a missing subsystem or an unexplained failure.
Additional physical revisions require their own stable identity, evidence,
startup contract, and applicability review; they are never aliases.
