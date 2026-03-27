{config, ...}: let
  inherit (config.cfgLib) matchFor hosts;

  bareCert = "kotfind.mywire.org";
  wildCert = "_.kotfind.mywire.org";
  domain = "kotfind.mywire.org";
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

      "*.${domain}" = {
        useACMEHost = wildCert;
        extraConfig = ''
          respond "This is {host}"
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
