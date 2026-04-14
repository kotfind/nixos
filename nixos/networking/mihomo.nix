{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (builtins) readFile;
  inherit (config) sops;
  inherit (config.cfgLib) enableFor hosts;
  inherit (lib) mkMerge;

  ph = sops.placeholder;

  mihomoConfig =
    generalConfig
    // {
      tun = tunConfig;
      dns = dnsConfig;

      proxy-providers = providersConfig;
      proxy-groups = groupsConfig;

      rules = rulesConfig;
      listeners = listenersConfig;
    };

  generalConfig = {
    mode = "rule";
    secret = ph."mihomo-secret";

    external-controller = "localhost:4343";
    allow-lan = false;

    find-process-mode = "always";
    log-level = "warning";

    geo-auto-update = true;
    geo-update-interval = 24; # 24h
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
    "DOMAIN-REGEX,(\\bmts.*)|(.*mts\\b),DIRECT"
    "DOMAIN-REGEX,(\\bsber.*)|(.*sber\\b),DIRECT"
    "DOMAIN-REGEX,(\\btbank.*)|(.*stbank\\b),DIRECT"
    "DOMAIN-REGEX,(\\bwildberries.*)|(.*wildberries\\b),DIRECT"
    "DOMAIN-REGEX,(\\bkinopoisk.*)|(.*kinopoisk\\b),DIRECT"
    "DOMAIN-REGEX,(\\bozon.*)|(.*ozon\\b),DIRECT"
    "DOMAIN-REGEX,(\\bvtb.*)|(.*vtb\\b),DIRECT"
    "DOMAIN-REGEX,(\\bavito.*)|(.*avito\\b),DIRECT"
    "DOMAIN-REGEX,(\\brutube.*)|(.*rutube\\b),DIRECT"
    "DOMAIN-REGEX,(\\bmos.*)|(.*mos\\b),DIRECT"
    "DOMAIN-REGEX,(\\bgosuslugi.*)|(.*gosuslugi\\b),DIRECT"

    "GEOSITE,category-gov-ru,DIRECT"
    "GEOSITE,category-media-ru,DIRECT"
    "GEOSITE,category-ru,DIRECT"
    "GEOSITE,yandex,DIRECT"
    "GEOSITE,vk,DIRECT"
    "GEOSITE,ozon,DIRECT"

    "GEOSITE,telegram,💰📦"
    "GEOSITE,google,💰📦"
    "GEOSITE,youtube,💰📦"

    "GEOIP,ru,DIRECT"

    "GEOIP,telegram,💰📦"

    "MATCH,💰📦" # or GLOBAL ?
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
        key = mkMerge [
          (enableFor hosts.pc "💰🔗/header/value/pc")
          (enableFor hosts.laptop "💰🔗/header/value/laptop")
        ];
      };
    };
    templates."mihomo-config.yml" = {
      content = readFile rawConfigFile;
      restartUnits = ["mihomo.service"];
    };
  };
}
