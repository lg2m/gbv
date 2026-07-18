# gbv

`gbv` is an accuracy-oriented Game Boy and Game Boy Color emulator written from scratch in [Veyr](https://github.com/veyr-lang/veyr).

The project is bootstrapped as a Veyr package. Emulator implementation begins
after the repository and toolchain contract are stable.

## Development

The Nix flake installs the SHA-256-pinned Veyr compiler directly into the
development shell. While the Veyr release is private, authenticate `gh` first:

```sh
gh auth status
direnv allow
scripts/check.sh
```

Without direnv:

```sh
export GBV_VEYR_TOOLCHAIN_TARBALL="$(scripts/fetch-veyr-toolchain.sh)"
nix develop --impure
scripts/check.sh
```

`scripts/check.sh` formats-checks, builds, and runs the bootstrap executable.
The expected output is:

```text
gbv bootstrap ok
```

## Principles

- Reproduce documented hardware behavior; never add game-specific compatibility hacks.
- Keep the emulated Machine deterministic and independent of host files, time, input, graphics, and audio devices.
- Model timing, bus activity, and the PPU accurately from the first implementation.
- Treat public hardware-derived Conformance ROMs as executable specifications.
- Keep commercial ROMs, Boot ROMs, extracted assets, and private compatibility data out of the repository and public CI.
- Implement emulator-specific facilities in `gbv`; change Veyr only for a proven language defect or a reusable platform contract.

## Planning documents

- [Domain glossary](./CONTEXT.md)
- [Product scope](./docs/product-scope.md)
- [Architecture](./docs/architecture.md)
- [Accuracy contract](./docs/accuracy-contract.md)
- [Clocking](./docs/clocking.md)
- [Hardware models](./docs/hardware-models.md)
- [PPU architecture](./docs/ppu.md)
- [Cartridges and RTC](./docs/cartridges-and-rtc.md)
- [Persistence, Snapshots, and replay](./docs/persistence.md)
- [Testing](./docs/testing.md)
- [Fixtures and licensing](./docs/fixtures-and-licensing.md)
- [Veyr boundary](./docs/veyr-boundary.md)
- [Roadmap](./docs/roadmap.md)
- [Published issue graph](./docs/issue-plan.md)
- [References](./docs/references.md)

## Legal

`gbv` does not provide games or Nintendo firmware. Users must supply ROM Images and optional Boot ROMs that they are legally permitted to use.

The project is licensed under the [MIT License](./LICENSE).
