{config, ...}: let
  inherit (config.cfgLib) matchFor users;
in {
  # services.blueman-applet.enable = matchFor users.kotfind;
  services.mpris-proxy.enable = matchFor users.kotfind;
}
