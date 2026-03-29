{
  pkgs,
  config,
  ...
}: let
  inherit (builtins) readFile;
  inherit (config) sops;

  ph = sops.placeholder;

  mihomoConfig = {
    mode = "rule";
    secret = ph.mihomoSecret;

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
    ${ph.mihomoProvider1Name} = httpProvider (mins 30) ph.mihomoProvider1Url {};
    ${ph.mihomoProvider2Name} = httpProvider (mins 5) ph.mihomoProvider2Url {};
  };

  groupsConfig = [
    (urlTestGroup ph.mihomoGroup1Name {use = [ph.mihomoProvider1Name];})
    (urlTestGroup ph.mihomoGroup2Name {use = [ph.mihomoProvider2Name];})
    (urlTestGroup "auto-all-group" {include-all = true;})
    (selectGroup "manual-all-group" {include-all = true;})
    (balanceGroup "balance-all-group" {include-all = true;})
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

  # -------------------- Group Helpers --------------------

  baseGroup = type: name: extra:
    {
      inherit name type;

      url = sampleUrl;
      interval = 6;
    }
    // extra;

  selectGroup = baseGroup "select";
  urlTestGroup = baseGroup "url-test";
  balanceGroup = baseGroup "load-balance";

  # -------------------- Provider Helpers --------------------

  baseProvider = type: interval: extra:
    {
      inherit type interval;

      override.udp = true;
    }
    // extra;

  httpProvider = interval: url: extra:
    baseProvider "http" interval ({inherit url;} // extra);

  # -------------------- Other Helpers --------------------

  toYaml = (pkgs.formats.yaml {}).generate;

  mins = m: m * 6;

  sampleUrl = "https://youtube.com";

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
      mihomoSecret = {
        sopsFile = ./mihomo.enc.yml;
        key = "secret";
      };

      mihomoProvider1Url = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/1/url";
      };
      mihomoProvider1Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/1/name";
      };
      mihomoProvider2Url = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/2/url";
      };
      mihomoProvider2Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/2/name";
      };

      mihomoGroup1Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/1/name";
      };
      mihomoGroup2Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/2/name";
      };
    };
    templates."mihomo-config.yml" = {
      content = readFile rawConfigFile;
      restartUnits = ["mihomo.service"];
    };
  };
}
