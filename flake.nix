{
  description = "gbv Game Boy and Game Boy Color emulator";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      lib = pkgs.lib;

      source = lib.cleanSourceWith {
        src = ./.;
        filter =
          path: type:
          let
            name = baseNameOf path;
          in
            !(lib.elem name [
              ".direnv"
              ".git"
              ".veyr"
              ".veyrc-dirlist"
              "_build"
              "dist"
              "gbv"
              "gbv.ll"
              "libgbv.a"
              "result"
            ]);
      };

      veyr-toolchain = pkgs.callPackage ./nix/veyr-toolchain.nix { };

      gbv = pkgs.stdenv.mkDerivation {
        pname = "gbv";
        version = "0.0.1-dev";
        src = source;

        nativeBuildInputs = [ veyr-toolchain ];

        buildPhase = ''
          runHook preBuild
          veyr build --profile release
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          install -Dm755 gbv "$out/bin/gbv"
          runHook postInstall
        '';

        meta = {
          description = "Accuracy-oriented Game Boy and Game Boy Color emulator";
          license = lib.licenses.mit;
          mainProgram = "gbv";
          platforms = [ "x86_64-linux" ];
        };
      };

      required = pkgs.runCommand "gbv-required-checks"
        {
          nativeBuildInputs = [
            gbv
            veyr-toolchain
            pkgs.bash
            pkgs.coreutils
            pkgs.nixpkgs-fmt
            pkgs.shellcheck
          ];
        } ''
        cp -R ${source} work
        chmod -R u+w work
        cd work
        GBV_BIN=${gbv}/bin/gbv GBV_SKIP_BUILD=1 bash scripts/check.sh
        touch "$out"
      '';

    in
    {
      packages.${system} = {
        inherit gbv veyr-toolchain;
        default = gbv;
      };

      checks.${system}.required = required;

      apps.${system}.default = {
        type = "app";
        program = "${gbv}/bin/gbv";
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          veyr-toolchain
          pkgs.bash
          pkgs.coreutils
          pkgs.gawk
          pkgs.gh
          pkgs.git
          pkgs.nixpkgs-fmt
          pkgs.shellcheck
        ];

        shellHook = ''
          echo "gbv development shell"
          echo "Veyr: $(veyr --version 2>/dev/null || printf 'pinned toolchain')"
          echo "Run: scripts/check.sh"
        '';
      };

      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
