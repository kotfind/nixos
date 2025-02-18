# This value is passed to outputs.nixosConfiguration.system

{ nixpkgs, home-manager, sops-nix, ... }@inputs:
let
    system = "x86_64-linux";

    specialArgs = {
        inherit inputs;
    };

    # A cfgLib module with it's configuration.
    # It's passed to both nixos and home-manager.
    cfgLibMod = { config, ... }: {
        imports = [ ./cfgLib ];

        cfgLib = {
            usersDef = {
                kotfind = {
                    email = "kotfind@yandex.ru";
                };

                root = {
                    homeDir = "/root";
                };
            };

            hostsDef = {
                pc = {
                    users = with config.cfgLib.users; [
                        kotfind
                        root
                    ];
                    data = {
                        hostname = "kotfindPC";
                    };
                };
                laptop = {
                    users = with config.cfgLib.users; [
                        kotfind
                        root
                    ];
                    data = {
                        hostname = "kotfindLT";
                    };
                };
            };

            host = import ./current-host.nix config.cfgLib.hosts;
        };
    };

    homeMod = { config, lib, ... }: {
        imports = [
            home-manager.nixosModules.home-manager
        ];

        home-manager = {
            sharedModules = [
                sops-nix.homeManagerModules.sops
                cfgLibMod
            ];

            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = specialArgs;

            users = lib.mapAttrs
                (userName: _userOnHost: {
                    home.username = userName;
                    imports = [ ./home ];
                })
                config.cfgLib.host.users;
        };
    };
in
nixpkgs.lib.nixosSystem {
    inherit specialArgs system;
    
    modules = [
        ./nixos
        cfgLibMod
        homeMod
        sops-nix.nixosModules.sops
    ];
}
