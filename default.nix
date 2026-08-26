# Returns nixosConfigurations.<host> for every host in ./profiles.nix
{
  system,
  nixpkgs,
  home-manager,
  sops-nix,
  nix-index-database,
  homepage,
  hostlib,
  ...
} @ inputs: let
  unfreePkgs = pkgs:
    with pkgs; [
      claude-code
      codeium
      hplipWithPlugin
      steam-unwrapped
      zoom-us
    ];

  homeMod = {...}: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs system;
      };
    };
  };
in
  hostlib.lib.eachHostSystem {
    nixosSystem = nixpkgs.lib.nixosSystem;

    homeManagerModule = home-manager.nixosModules.home-manager;

    profiles = import ./profiles.nix;

    systemModules = [
      ./system
      nix-index-database.nixosModules.nix-index
      homepage.nixosModules.default
      homeMod
      sops-nix.nixosModules.sops

      ({
        pkgs,
        lib,
        ...
      }: {
        nixpkgs.config.allowUnfreePredicate = pkg:
          builtins.elem
          (lib.getName pkg)
          (
            builtins.map
            (pkg: lib.getName pkg)
            (unfreePkgs pkgs)
          );
      })
    ];

    homeModules = [
      ./home
      sops-nix.homeManagerModules.sops
    ];
  }
