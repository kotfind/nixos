{
  config,
  pkgs,
  ...
}: let
  inherit (config.cfgLib) host;
in {
  networking = {
    hostName = host.data.hostname;

    networkmanager.enable = true;

    firewall.enable = false;
  };

  environment.systemPackages = with pkgs; [
    openssl
  ];
}
