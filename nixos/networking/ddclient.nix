{config, ...}: let
  inherit (config.cfgLib) hosts matchFor enableFor;
in {
  services.ddclient = {
    enable = matchFor hosts.pc;
    domains = ["kotfind.mywire.org"];
    server = "api.dynu.com";
    usev6 = "";
    verbose = true;
    secretsFile = config.sops.secrets.ddclientSecrets.path;
  };

  # ddclient's proxy option only seems to work with
  # https proxies (NOT http ones)
  systemd.services.ddclient.environment = {
    http_proxy = "http://127.0.0.1:1111";
    https_proxy = "http://127.0.0.1:1111";

    # only use proxy for getting an ip address
    no_proxy = "kotfind.mywire.org,api.dynu.com";
  };

  sops.secrets.ddclientSecrets = enableFor hosts.pc {
    sopsFile = ./ddclient.enc.env;
    format = "dotenv";
  };
}
