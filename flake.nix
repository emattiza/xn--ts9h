{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    nci = {
      url = "github:yusdacra/nix-cargo-integration";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    nci,
    ...
  }: let
    outputs = nci.lib.makeOutputs {
      root = ./.;
      config = common: {
        outputs.defaults = {
          app = "xn--ts9h";
          package = "xn--ts9h";
        };
      };
      overrides = {
        shell = common: prev: {
          packages =
            prev.packages
            ++ [
              common.pkgs.rust-analyzer
              common.pkgs.rustfmt
            ];
        };
      };
    };
  in
    outputs
    // {
      inherit (outputs) apps devShells;
    };
}
