{
  config,
  pkgs,
  ...
}: let
  inherit (config.hostlib) join trueFor mkFor hosts users;
  inherit (config.home) homeDirectory;
in {
  # XXX: secrets are installed for all users, though files
  # are linked correctly
  sops.secrets = {
    "kotfind@kotfindPC/ssh/id_rsa" = {
      path =
        (mkFor (join users.kotfind hosts.pc))
        "${homeDirectory}/.ssh/id_rsa";
    };

    "kotfind@kotfindPC/ssh/id_rsa.pub" = {
      path =
        (mkFor (join users.kotfind hosts.pc))
        "${homeDirectory}/.ssh/id_rsa.pub";
    };

    "kotfind@kotfindLT/ssh/id_rsa" = {
      path =
        (mkFor (join users.kotfind hosts.laptop))
        "${homeDirectory}/.ssh/id_rsa";
    };

    "kotfind@kotfindLT/ssh/id_rsa.pub" = {
      path =
        (mkFor (join users.kotfind hosts.laptop))
        "${homeDirectory}/.ssh/id_rsa.pub";
    };
  };

  programs.ssh = {
    enable = trueFor users.kotfind;
    enableDefaultConfig = false;
  };

  home.packages = mkFor users.kotfind (with pkgs; [
    sshfs
  ]);
}
