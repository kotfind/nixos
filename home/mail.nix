{config, ...}: let
  inherit (config.hostlib) trueFor users;
in {
  programs.thunderbird = {
    enable = trueFor users.kotfind;
    profiles.master = {
      isDefault = true;

      search = {
        default = "ddg";
        force = true;
      };

      # TODO: options and login
    };
  };
}
