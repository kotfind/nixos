{config, ...}: let
  inherit (config.cfgLib) host;
in {
  networking = {
    hostName = host.data.hostname;

    networkmanager.enable = true;

    firewall.enable = false;
  };

  programs.clash-verge = {
    enable = true;
    autoStart = true;
    serviceMode = true;
    tunMode = true;
  };
}
