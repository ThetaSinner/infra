{
  description = "A very basic flake";

  inputs = {
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, devshell }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;

          overlays = [ devshell.overlays.default ];
        };
      in {
        devShells.default = pkgs.devshell.mkShell {
          packages = with pkgs; [ git haskellPackages.ghc nixpkgs-fmt ];

          commands = [{
            name = "flakefmt";
            category = "format";
            command = "nix fmt flake.nix";
          }];
        };

        formatter = pkgs.nixfmt;
      });
}
