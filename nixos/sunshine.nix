{config, ...}: let
  inherit (config.cfgLib) matchFor hosts;
in {
  services.sunshine = {
    enable = matchFor hosts.pc;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}
