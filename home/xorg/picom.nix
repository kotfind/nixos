{config, ...}: let
  inherit (config.cfgLib) matchFor users;
in {
  services.picom.enable = matchFor users.kotfind;
}
