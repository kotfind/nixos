{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.cfgLib) matchFor enableFor users hosts;
  inherit (lib) getExe';
  inherit (pkgs) writeShellScript;

  xlockBin = getExe' pkgs.xlockmore "xlock";
  xrandrBin = getExe' pkgs.xorg.xrandr "xrandr";
  awkBin = getExe' pkgs.gawk "awk";
  lockCmd = "${xlockBin} -echokeys";

  setBrightness = writeShellScript "xidlelock-set-brightness" ''
    mapfile -t screens < <(${xrandrBin} | ${awkBin} '/ connected/{print $1}')
    for out in "''${screens[@]}"; do
      ${xrandrBin} --output "$out" --brightness "$1"
    done
  '';

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

  services.xidlehook = {
    enable = matchFor users.kotfind;
    timers = [
      {
        delay = 900; # 15 min
        command = "${setBrightness} .2";
        canceller = "${setBrightness} 1";
      }
      {
        delay = 10;
        command = "${setBrightness} 1; ${lockCmd}";
      }
    ];
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
