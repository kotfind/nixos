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
    log-level = "error";

    geo-auto-update = true;
    geo-update-interval = 24; # 24h
  };

  dnsConfig = rec {
    enable = true;
    listen = "0.0.0.0:1053";
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
        interval = 5; # 5s
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
      name = "Select";
      type = "select";
      url = testUrl;
      use = ["💰🔗"];
    }
    {
      name = "Balance";
      type = "load-balance";
      url = testUrl;
      use = ["💰🔗"];
    }
    {
      name = "Fastest";
      type = "url-test";
      url = testUrl;
      interval = 5; # 5s
      tolerance = 50;
      use = ["💰🔗"];
    }
    {
      name = "Entry";
      type = "select";
      proxies = ["Select" "Balance" "Fastest" "DIRECT"];
    }
  ];

  rulesConfig = [
    ph."mihomo-rules"

    "DOMAIN-SUFFIX,deepseek.com,DIRECT"

    "DOMAIN-SUFFIX,kant.ru,DIRECT"
    "GEOSITE,category-gov-ru,DIRECT"
    "GEOSITE,category-media-ru,DIRECT"
    "GEOSITE,category-ru,DIRECT"
    "GEOSITE,yandex,DIRECT"
    "GEOSITE,vk,DIRECT"
    "GEOSITE,ozon,DIRECT"

    "GEOSITE,telegram,Entry"
    "GEOSITE,google,Entry"
    "GEOSITE,youtube,Entry"

    "GEOIP,ru,DIRECT"

    "GEOIP,telegram,Entry"

    "MATCH,Entry" # or GLOBAL ?
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
        key = "provider/url";
      };
      "mihomo-💰🔗-header-name" = {
        sopsFile = ./mihomo.enc.yml;
        key = "provider/header/name";
      };
      "mihomo-💰🔗-header-value" = {
        sopsFile = ./mihomo.enc.yml;
        key = mkMerge [
          (enableFor hosts.pc "provider/header/value/pc")
          (enableFor hosts.laptop "provider/header/value/laptop")
        ];
      };
      "mihomo-rules" = {
        sopsFile = ./mihomo.enc.yml;
        key = "rules";
      };
    };
    templates."mihomo-config.yml" = {
      content = readFile rawConfigFile;
      restartUnits = ["mihomo.service"];
    };
  };
}
