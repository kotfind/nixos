# Generate CA's key & cert:
# $ openssl ecparam -genkey -name prime256v1 -out ca.key
# $ openssl req -subj "/CN=kotfindCA" -new -x509 -key ca.key -out ca.crt
#
# Generate mihomo's key:
# $ openssl req \
#       -subj "/CN=localhost" -addext "subjectAltName=DNS:localhost,DNS:*.localhost,IP:127.0.0.1" \
#       -new -key mihomo.key -out mihomo.csr
# $ openssl x509 \
#       -CA ca.crt -CAkey ca.key -CAserial ca.srl \
#       -copy_extensions copy -days 365 \
#       -req -in mihomo.csr -out mihomo.crt
#
{
  pkgs,
  config,
  ...
}: let
  inherit (builtins) readFile;
  inherit (config) sops;

  ph = sops.placeholder;
  sec = sops.secrets;

  mihomoConfig = {
    mode = "global";
    secret = ph.mihomoSecret;

    external-controller = "localhost:0"; # FIXME: disable
    external-controller-tls = "localhost:4343";

    allow-lan = false;

    tls = tlsConfig;
    tun = tunConfig;
    dns = dnsConfig;

    proxy-providers = providersConfig;
    proxy-groups = groupsConfig;
  };

  tlsConfig = {
    certificate = "${credDir}/mihomo.crt";
    private-key = "${credDir}/mihomo.key";
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
    # ${ph.mihomoProvider3Name} = httpProvider (mins 5) ph.mihomoProvider3Url {};
    # ${ph.mihomoProvider4Name} = httpProvider (mins 5) ph.mihomoProvider4Url {};
    # ${ph.mihomoProvider5Name} = httpProvider (mins 5) ph.mihomoProvider5Url {};
    # ${ph.mihomoProvider6Name} = httpProvider (mins 5) ph.mihomoProvider6Url {};
    # ${ph.mihomoProvider7Name} = httpProvider (mins 5) ph.mihomoProvider7Url {};
    # ${ph.mihomoProvider8Name} = httpProvider (mins 5) ph.mihomoProvider8Url {};
    # ${ph.mihomoProvider9Name} = httpProvider (mins 30) ph.mihomoProvider9Url {};
    # ${ph.mihomoProvider10Name} = httpProvider (mins 5) ph.mihomoProvider10Url {};
    # ${ph.mihomoProvider11Name} = httpProvider (mins 5) ph.mihomoProvider11Url {};
    # ${ph.mihomoProvider12Name} = httpProvider (mins 5) ph.mihomoProvider12Url {};
    # ${ph.mihomoProvider13Name} = httpProvider (mins 5) ph.mihomoProvider13Url {};
    # ${ph.mihomoProvider14Name} = httpProvider (mins 5) ph.mihomoProvider14Url {};
    # ${ph.mihomoProvider15Name} = httpProvider (mins 5) ph.mihomoProvider15Url {};
    # ${ph.mihomoProvider16Name} = httpProvider (mins 5) ph.mihomoProvider16Url {};
    # ${ph.mihomoProvider17Name} = httpProvider (mins 5) ph.mihomoProvider17Url {};
  };

  groupsConfig = [
    (urlTestGroup ph.mihomoGroup1Name {use = [ph.mihomoProvider1Name];})
    (urlTestGroup ph.mihomoGroup2Name {use = [ph.mihomoProvider2Name];})
    # (urlTestGroup ph.mihomoGroup3Name {use = [ph.mihomoProvider3Name];})
    # (urlTestGroup ph.mihomoGroup4Name {use = [ph.mihomoProvider4Name];})
    # (urlTestGroup ph.mihomoGroup5Name {use = [ph.mihomoProvider5Name];})
    # (urlTestGroup ph.mihomoGroup6Name {use = [ph.mihomoProvider6Name];})
    # (urlTestGroup ph.mihomoGroup7Name {use = [ph.mihomoProvider7Name];})
    # (urlTestGroup ph.mihomoGroup8Name {use = [ph.mihomoProvider8Name];})
    # (urlTestGroup ph.mihomoGroup9Name {use = [ph.mihomoProvider9Name];})
    # (urlTestGroup ph.mihomoGroup10Name {use = [ph.mihomoProvider10Name];})
    # (urlTestGroup ph.mihomoGroup11Name {use = [ph.mihomoProvider11Name];})
    # (urlTestGroup ph.mihomoGroup12Name {use = [ph.mihomoProvider12Name];})
    # (urlTestGroup ph.mihomoGroup13Name {use = [ph.mihomoProvider13Name];})
    # (urlTestGroup ph.mihomoGroup14Name {use = [ph.mihomoProvider14Name];})
    # (urlTestGroup ph.mihomoGroup15Name {use = [ph.mihomoProvider15Name];})
    # (urlTestGroup ph.mihomoGroup16Name {use = [ph.mihomoProvider16Name];})
    # (urlTestGroup ph.mihomoGroup17Name {use = [ph.mihomoProvider17Name];})
    (urlTestGroup "auto-all-group" {include-all = true;})
    (selectGroup "manual-all-group" {include-all = true;})
    (balanceGroup "balance-all-group" {include-all = true;})
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

  # The $CREDENTIALS_DIRECTORY env var won't eval in some contexts,
  # so I'm hardcoding it.
  credDir = "/run/credentials/mihomo.service";

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
    secrets = {
      mihomoSecret = {
        sopsFile = ./mihomo.enc.yml;
        key = "secret";
      };

      mihomoTlsKey = {
        sopsFile = ./mihomo.enc.key;
        format = "binary";
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
      mihomoProvider3Url = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/3/url";
      };
      mihomoProvider3Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/3/name";
      };
      mihomoProvider4Url = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/4/url";
      };
      mihomoProvider4Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/4/name";
      };
      mihomoProvider5Url = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/5/url";
      };
      mihomoProvider5Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/5/name";
      };
      mihomoProvider6Url = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/6/url";
      };
      mihomoProvider6Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/6/name";
      };
      mihomoProvider7Url = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/7/url";
      };
      mihomoProvider7Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/7/name";
      };
      mihomoProvider8Url = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/8/url";
      };
      mihomoProvider8Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/8/name";
      };
      mihomoProvider9Url = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/9/url";
      };
      mihomoProvider9Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/9/name";
      };
      mihomoProvider10Url = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/10/url";
      };
      mihomoProvider10Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/10/name";
      };
      mihomoProvider11Url = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/11/url";
      };
      mihomoProvider11Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/11/name";
      };
      mihomoProvider12Url = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/12/url";
      };
      mihomoProvider12Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/12/name";
      };
      mihomoProvider13Url = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/13/url";
      };
      mihomoProvider13Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/13/name";
      };
      mihomoProvider14Url = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/14/url";
      };
      mihomoProvider14Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/14/name";
      };
      mihomoProvider15Url = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/15/url";
      };
      mihomoProvider15Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/15/name";
      };
      mihomoProvider16Url = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/16/url";
      };
      mihomoProvider16Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/16/name";
      };
      mihomoProvider17Url = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/17/url";
      };
      mihomoProvider17Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "providers/17/name";
      };

      mihomoGroup1Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/1/name";
      };
      mihomoGroup2Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/2/name";
      };
      mihomoGroup3Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/3/name";
      };
      mihomoGroup4Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/4/name";
      };
      mihomoGroup5Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/5/name";
      };
      mihomoGroup6Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/6/name";
      };
      mihomoGroup7Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/7/name";
      };
      mihomoGroup8Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/8/name";
      };
      mihomoGroup9Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/9/name";
      };
      mihomoGroup10Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/10/name";
      };
      mihomoGroup11Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/11/name";
      };
      mihomoGroup12Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/12/name";
      };
      mihomoGroup13Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/13/name";
      };
      mihomoGroup14Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/14/name";
      };
      mihomoGroup15Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/15/name";
      };
      mihomoGroup16Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/16/name";
      };
      mihomoGroup17Name = {
        sopsFile = ./mihomo.enc.yml;
        key = "groups/17/name";
      };
    };
    templates."mihomo-config.yml" = {
      content = readFile rawConfigFile;
      restartUnits = ["mihomo.service"];
    };
  };

  systemd.services.mihomo = {
    environment.SAFE_PATHS = credDir;
    serviceConfig.LoadCredential = [
      "mihomo.crt:${./mihomo.crt}"
      "mihomo.key:${sec.mihomoTlsKey.path}"
    ];
  };

  security.pki.certificateFiles = [./ca.crt];
}
