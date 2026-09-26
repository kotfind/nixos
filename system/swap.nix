{
  config,
  lib,
  ...
}: let
  inherit (config.hostlib) hosts mkFor;
in {
  swapDevices = mkFor hosts.pc [
    {
      device = lib.mkForce "/var/swapfile";
      label = "swapfile";
      size = 64 * 1024; # 64 GB
    }
  ];
}
