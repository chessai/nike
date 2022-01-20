{
  description = "nike nixos flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
  };

  outputs =
    { self
    , nixpkgs
    , ...
    }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      legacyPackages = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        nike = lib.nixosSystem {
          inherit system;
          modules =
            let
              mainModule = import ./configuration.nix;
            in
            [
              mainModule
            ];
         };
      };
    };
}
