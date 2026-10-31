{
  config,
  lib,
  ...
}: let
  inherit (config.hostlib) hosts trueFor mkFor;
in {
  services.ddclient = {
    enable = trueFor hosts.pc;
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

  # fixes random ddclient failures
  users.users.ddclient = mkFor hosts.pc {
    isSystemUser = true;
    group = "ddclient";
  };
  users.groups.ddclient = mkFor hosts.pc {};

  systemd.services.ddclient.serviceConfig = mkFor hosts.pc {
    DynamicUser = lib.mkForce false;
    User = "ddclient";
    Group = "ddclient";
  };

  sops.secrets.ddclientSecrets = mkFor hosts.pc {
    sopsFile = ./ddclient.enc.env;
    format = "dotenv";
  };
}
