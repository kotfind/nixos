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

  # manually setting a passthrough listener,
  # as config's `proxy` option does not seem work
  systemd.services.ddclient.environment = {
    http_proxy = "127.0.0.1:1111";
    https_proxy = "127.0.0.1:1111";
  };

  sops.secrets.ddclientSecrets = enableFor hosts.pc {
    sopsFile = ./ddclient.enc.env;
    format = "dotenv";
  };
}
