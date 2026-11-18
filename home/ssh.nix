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
    "kotfind@kotfindPC/ssh/id_ed25519" = {
      path =
        (mkFor (join users.kotfind hosts.pc))
        "${homeDirectory}/.ssh/id_ed25519";
    };

    "kotfind@kotfindPC/ssh/id_ed25519.pub" = {
      path =
        (mkFor (join users.kotfind hosts.pc))
        "${homeDirectory}/.ssh/id_ed25519.pub";
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

  services.vscode-server.enable = trueFor users.kotfind;

  home.packages = mkFor users.kotfind (with pkgs; [
    sshfs
  ]);
}
