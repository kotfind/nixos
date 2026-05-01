{
  config,
  pkgs,
  ...
}: let
  inherit (config.cfgLib) matchFor enableFor hosts users;
  inherit (config.home) homeDirectory;
in {
  # XXX: secrets are installed for all users, though files
  # are linked correctly
  sops.secrets = {
    "kotfind@kotfindPC/ssh/id_rsa" = {
      path =
        (enableFor hosts.pc.users.kotfind)
        "${homeDirectory}/.ssh/id_rsa";
    };

    "kotfind@kotfindPC/ssh/id_rsa.pub" = {
      path =
        (enableFor hosts.pc.users.kotfind)
        "${homeDirectory}/.ssh/id_rsa.pub";
    };

    "kotfind@kotfindLT/ssh/id_rsa" = {
      path =
        (enableFor hosts.laptop.users.kotfind)
        "${homeDirectory}/.ssh/id_rsa";
    };

    "kotfind@kotfindLT/ssh/id_rsa.pub" = {
      path =
        (enableFor hosts.laptop.users.kotfind)
        "${homeDirectory}/.ssh/id_rsa.pub";
    };
  };

  programs.ssh = {
    enable = matchFor users.kotfind;
    enableDefaultConfig = false;
  };

  home.packages = enableFor users.kotfind (with pkgs; [
    sshfs
  ]);
}
