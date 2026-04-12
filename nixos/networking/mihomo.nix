{
  pkgs,
  config,
  ...
}: let
  inherit (builtins) readFile;
  inherit (config) sops;

  ph = sops.placeholder;

  mihomoConfig = {
    log-level = "warning";

    mode = "rule";
    secret = ph."mihomo-secret";

    external-controller = "localhost:4343";

    allow-lan = false;
    find-process-mode = "always";

    tun = tunConfig;
    dns = dnsConfig;

    proxy-providers = providersConfig;
    proxy-groups = groupsConfig;

    rules = rulesConfig;
    listeners = listenersConfig;
  };

  dnsConfig = rec {
    enable = true;
    listen = "0.0.0.0:53";
    default-nameserver = nameserver;
    nameserver = [
      "8.8.8.8"
      "1.1.1.1"
    ];
  };

  tunConfig = {
    enable = true;
    stack = "system";
    strict-route = true;
    dns-hijack = [
      "any:53"
      "tcp://any:53"
    ];
  };

  providersConfig = {
    "💰🔗" = {
      type = "http";

      url = ph."mihomo-💰🔗-url";
      header.${ph."mihomo-💰🔗-header-name"} = [ph."mihomo-💰🔗-header-value"];

      health-check = {
        enable = true;
        url = testUrl;
        interval = 30; # 30s
        timeout = 500; # 0.5s
        lazy = false;
        expected-status = 204; # 204 No Content
      };

      override = {
        tls = true;
        udp = true;
        ech-options.enable = true;
      };
    };
  };

  groupsConfig = [
    {
      name = "💰📦";
      type = "select";
      url = testUrl;
      use = ["💰🔗"];
    }
  ];

  rulesConfig = [
    "MATCH,GLOBAL"
  ];

  listenersConfig = [
    {
      name = "passthrough-listener";
      type = "http";
      port = "1111";
      proxy = "DIRECT";
      listen = "127.0.0.1";
    }
  ];

  # -------------------- Helpers --------------------

  toYaml = (pkgs.formats.yaml {}).generate;

  testUrl = "http://www.gstatic.com/generate_204";

  rawConfigFile = toYaml "mihomo-config-raw.yml" mihomoConfig;
in {
  services.mihomo = {
    enable = true;
    tunMode = true;
    processesInfo = true;
    webui = pkgs.metacubexd;
    configFile = sops.templates."mihomo-config.yml".path;
  };

  sops = {
    secrets = {
      "mihomo-secret" = {
        sopsFile = ./mihomo.enc.yml;
        key = "secret";
      };
      "mihomo-💰🔗-url" = {
        sopsFile = ./mihomo.enc.yml;
        key = "💰🔗/url";
      };
      "mihomo-💰🔗-header-name" = {
        sopsFile = ./mihomo.enc.yml;
        key = "💰🔗/header/name";
      };
      "mihomo-💰🔗-header-value" = {
        sopsFile = ./mihomo.enc.yml;
        key = "💰🔗/header/value";
      };
    };
    templates."mihomo-config.yml" = {
      content = readFile rawConfigFile;
      restartUnits = ["mihomo.service"];
    };
  };
}
