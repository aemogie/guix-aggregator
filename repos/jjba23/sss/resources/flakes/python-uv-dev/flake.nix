{
  description = "A flake.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        commonPackages = with pkgs;
          [ python313 uv zlib git curl wget cmake ]
          ++ (with pkgs; [ gcc stdenv.cc.cc.lib ]);

        runScript = pkgs.writeShellScriptBin "run-script" ''
          #!/usr/bin/env bash
          source .venv/bin/activate
        '';

        baseEnvSetup = pkgs: ''
          # Set up the Python virtual environment with uv
          test -d .venv || ${pkgs.uv}/bin/uv venv .venv
          export VIRTUAL_ENV="$(pwd)/.venv"
          export PATH="$VIRTUAL_ENV/bin:$PATH"
          export LD_LIBRARY_PATH=${
            pkgs.lib.makeLibraryPath commonPackages
          }:$LD_LIBRARY_PATH
        '';

        mkLinuxShells = pkgs: {
          default = pkgs.mkShell {
            buildInputs = commonPackages;
            shellHook = ''
              ${baseEnvSetup pkgs}
              # Run the full interactive script
              ${runScript}/bin/run-script
            '';
          };
        };
        shells = mkLinuxShells pkgs;
      in {
        devShells = shells;
        devShell = shells.default;
      });
}

