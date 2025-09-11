# This value is passed to outputs.nixosConfiguration.default
{
  system,
  nixpkgs,
  home-manager,
  sops-nix,
  nix-index-database,
  ...
} @ inputs: let
  specialArgs = {
    inherit inputs system;
  };

  unfreePkgs = pkgs:
    with pkgs; [
      zoom-us
      codeium
      steam-unwrapped
    ];

  homeMod = {
    config,
    lib,
    ...
  }: {
    imports = [
      home-manager.nixosModules.home-manager
    ];

    home-manager = {
      sharedModules = [
        sops-nix.homeManagerModules.sops
        ./profiles.nix
      ];

      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = specialArgs;

      users =
        lib.mapAttrs
        (userName: _userOnHost: {
          home.username = userName;
          imports = [./home];
        })
        config.cfgLib.host.users;
    };
  };
in
  nixpkgs.lib.nixosSystem {
    inherit specialArgs system;

    modules = [
      ./nixos
      ./profiles.nix
      nix-index-database.nixosModules.nix-index
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
  }
