{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (builtins) readFile listToAttrs;
  inherit (config) sops;
  inherit (lib.attrsets) nameValuePair mapAttrsRecursive mapAttrsToListRecursive;

  mihomoConfig = {
    mode = "global";
    secret = ph.secret;

    allow-lan = false;
    external-controller = "localhost:4343"; # FIXME: https

    tun = tunConfig;
    dns = dnsConfig;

    proxy-providers = providersConfig;
    proxy-groups = groupsConfig;
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
    ${ph.provider-1-name} = httpProvider (mins 30) ph.provider-1-url {};
    ${ph.provider-2-name} = httpProvider (mins 5) ph.provider-2-url {};
  };

  groupsConfig = [
    (urlTestGroup ph.group-1-name {use = [ph.provider-1-name];})
    (urlTestGroup ph.group-2-name {use = [ph.provider-2-name];})
    (selectGroup "manual-group" {include-all = true;})
  ];

  secrets = {
    secret = "common/mihomo/secret";

    provider-1-url = "common/mihomo/providers/1/url";
    provider-1-name = "common/mihomo/providers/1/name";

    provider-2-url = "common/mihomo/providers/2/url";
    provider-2-name = "common/mihomo/providers/2/name";

    group-1-name = "common/mihomo/groups/1/name";
    group-2-name = "common/mihomo/groups/2/name";
  };

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

  # -------------------- Provider Helpers --------------------

  baseProvider = type: interval: extra:
    {
      inherit type interval;

      override.udp = true;
    }
    // extra;

  httpProvider = interval: url: extra:
    baseProvider "http" interval ({inherit url;} // extra);

  # -------------------- Sops Helpers --------------------

  ph = mapAttrsRecursive (_path: qual: sops.placeholder.${qual}) secrets;

  secretDefs = listToAttrs (
    map
    (qual: nameValuePair qual {})
    (mapAttrsToListRecursive (_path: qual: qual) secrets)
  );

  # -------------------- Other Helpers --------------------

  toYaml = (pkgs.formats.yaml {}).generate;

  mins = m: m * 6;

  # -------------------- Other --------------------

  sampleUrl = "https://youtube.com";

  rawConfigFile = toYaml "mihomo-config-raw.yml" mihomoConfig;
in {
  services.mihomo = {
    enable = true;
    tunMode = true;
    webui = pkgs.metacubexd;
    configFile = sops.templates."mihomo-config.yml".path;
  };

  sops = {
    secrets = secretDefs;
    templates."mihomo-config.yml" = {
      content = readFile rawConfigFile;
      restartUnits = ["mihomo.service"];
    };
  };
}
