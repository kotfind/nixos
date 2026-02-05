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
  };

  groupsConfig = [
    (urlTestGroup ph.mihomoGroup1Name {use = [ph.mihomoProvider1Name];})
    (urlTestGroup ph.mihomoGroup2Name {use = [ph.mihomoProvider2Name];})
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

  systemd.services.mihomo = {
    environment.SAFE_PATHS = credDir;
    serviceConfig.LoadCredential = [
      "mihomo.crt:${./mihomo.crt}"
      "mihomo.key:${sec.mihomoTlsKey.path}"
    ];
  };

  security.pki.certificateFiles = [./ca.crt];
}
