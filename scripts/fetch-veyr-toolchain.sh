#!/usr/bin/env bash

set -euo pipefail

die() {
  printf 'fetch-veyr-toolchain: %s\n' "$1" >&2
  exit 2
}

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
pin="${GBV_VEYR_TOOLCHAIN_PIN:-$repo_root/nix/veyr-toolchain-pin.nix}"
cache_root="${GBV_VEYR_CACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/gbv/veyr-toolchains}"

[[ -f "$pin" ]] || die "pin not found: $pin"

pin_field() {
  awk -v key="$1" '
    $0 ~ "^[ \\t]*" key "[ \\t]*=" {
      sub(/^[^=]*=[ \\t]*/, "")
      sub(/;[ \\t]*$/, "")
      gsub(/^"|"$/, "")
      print
      exit
    }
  ' "$pin"
}

repository="$(pin_field repository)"
release="$(pin_field release)"
asset="$(pin_field artifact)"
expected_sha="$(pin_field sha256)"

[[ "$repository" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] || die "invalid repository pin"
[[ "$release" =~ ^[A-Za-z0-9._-]+$ ]] || die "invalid release pin"
[[ "$asset" =~ ^[A-Za-z0-9._-]+$ ]] || die "invalid asset pin"
[[ "$expected_sha" =~ ^[0-9a-f]{64}$ ]] || die "invalid SHA-256 pin"

verify() {
  local candidate="$1"
  [[ -f "$candidate" ]] || return 1
  [[ "$(sha256sum "$candidate" | awk '{print $1}')" == "$expected_sha" ]]
}

if [[ -n "${GBV_VEYR_TOOLCHAIN_TARBALL:-}" ]]; then
  override="$(realpath -- "$GBV_VEYR_TOOLCHAIN_TARBALL")"
  verify "$override" || die "GBV_VEYR_TOOLCHAIN_TARBALL does not match the pinned SHA-256"
  printf '%s\n' "$override"
  exit 0
fi

mkdir -p -- "$cache_root"
archive="$cache_root/$expected_sha-$asset"
if verify "$archive"; then
  printf '%s\n' "$(realpath -- "$archive")"
  exit 0
fi

command -v gh >/dev/null 2>&1 || die "gh is required to fetch the private Veyr release"
gh auth status -h github.com >/dev/null 2>&1 \
  || die "GitHub CLI is not authenticated; run: gh auth login -h github.com"

temporary="$(mktemp -d "${TMPDIR:-/tmp}/gbv-veyr-toolchain.XXXXXX")"
trap 'rm -rf -- "$temporary"' EXIT

printf 'fetch-veyr-toolchain: downloading %s/%s/%s\n' "$repository" "$release" "$asset" >&2
gh release download "$release" \
  --repo "$repository" \
  --pattern "$asset" \
  --dir "$temporary"

downloaded="$temporary/$asset"
verify "$downloaded" || die "downloaded asset failed the pinned SHA-256 check"
install -m 0644 "$downloaded" "$archive.tmp.$$"
mv -f -- "$archive.tmp.$$" "$archive"
printf '%s\n' "$(realpath -- "$archive")"
