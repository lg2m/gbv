#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

veyr fmt --check .
veyr test . --seed 638 --jobs 1
nixpkgs-fmt --check flake.nix nix/*.nix
shellcheck scripts/*.sh

if [[ "${GBV_SKIP_BUILD:-0}" != 1 ]]; then
  veyr build
  export GBV_BIN="$repo_root/gbv"
fi

binary="${GBV_BIN:-$repo_root/gbv}"
[[ -x "$binary" ]] || {
  printf 'check: executable not found: %s\n' "$binary" >&2
  exit 1
}
[[ "$($binary)" == "gbv bootstrap ok" ]] || {
  printf 'check: bootstrap output mismatch\n' >&2
  exit 1
}

printf 'check: all required checks passed\n'
