{
  pkgs,
  config,
  ...
}: let
  inherit (config.cfgLib) enableFor users;
  inherit (config.home) homeDirectory;
in {
  sops = {
    age = {
      sshKeyPaths = [];
      keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
    };

    # TODO: remove
    defaultSopsFile = ./default.yaml;
  };

  home.packages =
    enableFor users.kotfind
    (with pkgs; [
      sops
      age
    ]);
}
