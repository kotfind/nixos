{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.cfgLib) matchFor enableFor users hosts;
  inherit (lib) getExe';

  xlockBin = getExe' pkgs.xlockmore "xlock";

  userName = config.cfgLib.user.name;
  homeDir = config.home.homeDirectory;
in {
  xsession.enable = matchFor users.kotfind;

  services.lxqt-policykit-agent.enable = matchFor users.kotfind;

  services.network-manager-applet.enable = matchFor users.kotfind;

  services.picom.enable = matchFor users.kotfind;

  services.batsignal = {
    enable = matchFor hosts.laptop.users.kotfind;
    extraArgs = [
      "-f"
      "99"
      "-w"
      "30"
      "-c"
      "10"
      "-d"
      "5"
      "-p"
    ];
  };

  services.gpg-agent = {
    enable = matchFor users.kotfind;
    pinentry.package = pkgs.pinentry-rofi;
  };

  services.screen-locker = {
    enable = matchFor users.kotfind;
    lockCmd = "${xlockBin} -echokeys";
  };

  # for some java gui apps to work:
  home.sessionVariables._JAVA_AWT_WM_NONREPARENTING = 1;

  systemd.user.tmpfiles.rules =
    enableFor users.kotfind
    [
      # Type  Path                  Mode  User         Group   Age  Argument
      "d      /tmp/downloads        0755  ${userName}  users   -    -"
      "d      /tmp/screenshots      0755  ${userName}  users   -    -"
      "L+     ${homeDir}/Downloads  -     -            -       -    /tmp/downloads"
    ];
}
