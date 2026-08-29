{config, ...}: let
  inherit (config.hostlib) hosts mkFor trueFor;
in {
  hardware.graphics.enable = trueFor hosts.pc;
  services.xserver.videoDrivers = mkFor hosts.pc ["nvidia"];
  hardware.nvidia.open = trueFor hosts.pc;
}
