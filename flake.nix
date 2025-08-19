{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.05";
    utils.url = "github:numtide/flake-utils";
    dev-env.url = "github:kymzky/dev-env";
  };

  outputs = { self, nixpkgs, utils, dev-env }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        baseShell = dev-env.devShell.${system};
      in
      {
        devShell = pkgs.stdenv.mkDerivation {
          name = ".dotfiles";
          dontBuild = baseShell.buildInputs;
          dontInstall = baseShell.dontInstall;
          
          buildInputs = baseShell.buildInputs ++ [
            pkgs.ansible
            pkgs.go-task
          ];
          
          shellHook = ''
            export EXTRA_COMMANDS="
              set -ga PATH ${pkgs.ansible}/bin
              set -ga PATH ${pkgs.go-task}/bin
            "
            ${baseShell.shellHook}
          '';
        };
      });
}
