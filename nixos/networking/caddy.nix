{config, ...}: let
  inherit (config.cfgLib) matchFor hosts;

  domain = "kotfind.mywire.org";

  bareCert = "kotfind.mywire.org";
  wildCert = "_.kotfind.mywire.org";

  navidromePort = config.services.navidrome.settings.Port;
in {
  services.caddy = {
    enable = matchFor hosts.pc;
    enableReload = false;

    globalConfig = ''
      admin off
      auto_https disable_certs
    '';

    virtualHosts = {
      ${domain} = {
        useACMEHost = bareCert;
        extraConfig = ''
          respond "Hello, world!"
        '';
      };

      "music.${domain}" = {
        useACMEHost = wildCert;
        extraConfig = ''
          reverse_proxy :${toString navidromePort}
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
