{config, ...}: let
  inherit (config.cfgLib) matchFor users;
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
}
