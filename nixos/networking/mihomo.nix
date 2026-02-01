{pkgs, ...}: let
  mihomoConfig = {
    mode = "global";
    # FIXME: actual secret
    secret = "SECRET";

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

  dummyUrl = "http://www.gstatic.com/generate_204";

  providersConfig = {
    # FIXME: actual url
    http-1-provider = httpProvider (mins 30) dummyUrl {};

    # FIXME: actual url
    http-2-provider = httpProvider (mins 5) dummyUrl {};
  };

  groupsConfig = [
    (urlTestGroup "url-test-1-group" {use = ["http-1-provider"];})
    (urlTestGroup "url-test-2-group" {use = ["http-2-provider"];})
    (selectGroup "manual-group" {include-all = true;})
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

  # -------------------- Other --------------------

  sampleUrl = "https://youtube.com";
in {
  services.mihomo = {
    enable = true;
    tunMode = true;
    webui = pkgs.metacubexd;
    configFile = toYaml "mihomo-config-raw.yml" mihomoConfig;
  };
}
