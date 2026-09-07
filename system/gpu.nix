{config, ...}: let
  inherit (config.hostlib) hosts mkFor trueFor;
in {
  hardware.graphics.enable = trueFor hosts.pc;
  services.xserver.videoDrivers = mkFor hosts.pc ["nvidia"];
  hardware.nvidia.open = trueFor hosts.pc;

  services.xserver.config = mkFor hosts.pc ''
    Section "Screen"
      Identifier "Screen-nvidia[0]"
      Option "metamodes" "HDMI-0: 1920x1080_60 +0+0"
    EndSection
  '';
}
