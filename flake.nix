{
    description = "NixOS configuration";

    nixConfig = {
        extra-substituters = [
            "https://nix-community.cachix.org"
        ];
        extra-trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
    };

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
        home-manager.url = "github:nix-community/home-manager/release-24.11";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { nixpkgs, home-manager, ... }: {
        nixosConfigurations.system = let
            cfg = import ./cfg.nix;
            # utils = import ./utils { pkgs = nixpkgs; };
            specialArgs = {
                inherit cfg;
            };
        in nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";
            modules = [
                ./nixos/configuration.nix
                ./nixos/hardware-configuration.nix

                home-manager.nixosModules.home-manager
                {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        extraSpecialArgs = specialArgs;
                        users.${cfg.username} = import ./home;
                    };
                }
            ];
        };
    };
}
