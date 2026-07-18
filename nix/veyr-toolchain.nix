{ lib, pkgs }:

let
  pin = import ./veyr-toolchain-pin.nix;
  archiveEnv = builtins.getEnv "GBV_VEYR_TOOLCHAIN_TARBALL";
  archive =
    if archiveEnv != "" then
      builtins.path
        {
          path = archiveEnv;
          name = pin.artifact;
          recursive = false;
          sha256 = pin.hash;
        }
    else
      pkgs.fetchurl {
        name = pin.artifact;
        inherit (pin) url hash;
      };
in
pkgs.stdenv.mkDerivation {
  pname = "gbv-veyr-toolchain";
  inherit (pin) version;
  src = archive;

  nativeBuildInputs = [
    pkgs.autoPatchelfHook
    pkgs.makeWrapper
    pkgs.zstd
  ];
  buildInputs = [ pkgs.stdenv.cc.cc.lib ];

  unpackPhase = ''
    runHook preUnpack
    mkdir source
    tar --use-compress-program=unzstd -xf "$src" -C source
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    root=""
    for candidate in source/veyr-toolchain-*; do
      if [ -d "$candidate" ]; then
        root="$candidate"
        break
      fi
    done
    [ -n "$root" ] || { echo "Veyr toolchain root not found" >&2; exit 1; }
    [ -x "$root/bin/veyrc" ] || { echo "veyrc not found in pinned toolchain" >&2; exit 1; }

    install -Dm755 "$root/bin/veyrc" "$out/bin/.veyrc-unwrapped"
    mkdir -p "$out/lib"
    for tier in core std vendor; do
      [ -d "$root/lib/$tier" ] || { echo "Veyr $tier library tier not found" >&2; exit 1; }
      cp -R "$root/lib/$tier" "$out/lib/$tier"
    done

    toolPath=${lib.makeBinPath [
      pkgs.llvmPackages.clang
      pkgs.bash
      pkgs.binutils
      pkgs.coreutils
      pkgs.pkg-config
      pkgs.util-linux
    ]}
    makeWrapper "$out/bin/.veyrc-unwrapped" "$out/bin/veyrc" \
      --prefix PATH : "$toolPath" \
      --set-default VEYR_ROOT "$out/lib"
    makeWrapper "$out/bin/.veyrc-unwrapped" "$out/bin/veyr" \
      --prefix PATH : "$toolPath" \
      --set-default VEYR_ROOT "$out/lib"

    runHook postInstall
  '';

  meta = {
    description = "SHA-256-pinned Veyr toolchain used to build gbv";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
