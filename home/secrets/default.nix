{
  pkgs,
  config,
  ...
}: {
  sops = {
    age = {
      sshKeyPaths = [];
      # FIXME: custom user
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    };

    defaultSopsFile = ./default.yaml;
  };

  home.packages =
    (with config.cfgLib; enableFor users.kotfind)
    (with pkgs; [
      sops
      age
    ]);
}
