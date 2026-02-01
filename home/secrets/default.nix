{
  pkgs,
  config,
  ...
}: let
  inherit (config.cfgLib) enableFor users;
in {
  sops = {
    age = {
      sshKeyPaths = [];
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    };

    defaultSopsFile = ./default.yaml;
  };

  home.packages =
    enableFor users.kotfind
    (with pkgs; [
      sops
      age
    ]);
}
