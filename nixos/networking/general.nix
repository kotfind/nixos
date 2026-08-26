{
  config,
  pkgs,
  ...
}: let
  inherit (config.hostlib) _curHost;
in {
  networking = {
    hostName = _curHost.hostname;

    networkmanager.enable = true;

    firewall.enable = false;
  };

  environment.systemPackages = with pkgs; [
    openssl
  ];
}
