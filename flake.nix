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
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        nvim-spl-ru = { url = "https://ftp.nluug.nl/pub/vim/runtime/spell/ru.utf-8.spl"; flake = false; };
        nvim-sug-ru = { url = "https://ftp.nluug.nl/pub/vim/runtime/spell/ru.utf-8.sug"; flake = false; };
        nvim-spl-en = { url = "https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.spl"; flake = false; };
        nvim-sug-en = { url = "https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.sug"; flake = false; };

        sops-nix.url = "github:Mic92/sops-nix";
        sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { nixpkgs, home-manager, sops-nix, ... }@inputs: {
        nixosConfigurations.system = let
                cfg = import ./cfg.nix;
                # utils = import ./utils { pkgs = nixpkgs; };
                specialArgs = {
                    inherit cfg inputs;
                };
            in nixpkgs.lib.nixosSystem {
                inherit specialArgs;
                system = "x86_64-linux";

                modules = [
                    ./nixos

                    sops-nix.nixosModules.sops

                    home-manager.nixosModules.home-manager
                    {
                        home-manager = {
                            sharedModules = [
                                sops-nix.homeManagerModules.sops
                            ];

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
