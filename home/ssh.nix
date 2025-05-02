{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) escapeShellArg;
  inherit (config.cfgLib) matchFor enableFor hosts users;
  inherit (config.sops) secrets;
in {
  # XXX: secrets are installed for all users, though files
  # are linked correctly
  sops.secrets = {
    kotfindPC-ip-address = {};

    "kotfind@kotfindPC/ssh/id_rsa" = {
      path =
        (enableFor hosts.pc.users.kotfind)
        "${config.home.homeDirectory}/.ssh/id_rsa";
    };

    "kotfind@kotfindPC/ssh/id_rsa.pub" = {
      path =
        (enableFor hosts.pc.users.kotfind)
        "${config.home.homeDirectory}/.ssh/id_rsa.pub";
    };

    "kotfind@kotfindLT/ssh/id_rsa" = {
      path =
        (enableFor hosts.laptop.users.kotfind)
        "${config.home.homeDirectory}/.ssh/id_rsa";
    };

    "kotfind@kotfindLT/ssh/id_rsa.pub" = {
      path =
        (enableFor hosts.laptop.users.kotfind)
        "${config.home.homeDirectory}/.ssh/id_rsa.pub";
    };
  };

  programs.ssh = {
    enable = matchFor users.kotfind;
  };

  home.packages = (enableFor users.kotfind) (with pkgs; [
    sshfs
  ]);

  programs.bash.bashrcExtra =
    (enableFor users.kotfind)
    ''
      export kotfindPC="''$(cat ${escapeShellArg secrets.kotfindPC-ip-address.path})"
    '';
}
