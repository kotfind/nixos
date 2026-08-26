{
  pkgs,
  config,
  ...
}: let
  inherit (config.hostlib) mkFor users;
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
    mkFor users.kotfind
    (with pkgs; [
      sops
      age
    ]);
}
