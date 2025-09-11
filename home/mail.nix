{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.cfgLib) enableFor matchFor users;

  autostartService = import ./xorg/autostart-service.nix {inherit lib;};
in {
  programs.thunderbird = {
    enable = matchFor users.kotfind;
    profiles.master = {
      isDefault = true;

      search = {
        default = "ddg";
        force = true;
      };

      # TODO: options and login
    };
  };

  home.packages = enableFor users.kotfind (with pkgs; [
    birdtray
  ]);

  systemd.user.services.birdtray = enableFor users.kotfind (autostartService {
    cmd = pkgs.birdtray;
  });
}
