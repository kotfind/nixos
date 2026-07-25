{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.cfgLib) matchFor users;
  inherit (lib) getExe';
  inherit (pkgs) writeShellScript;

  xlockBin = getExe' pkgs.xlockmore "xlock";
  touchBin = getExe' pkgs.coreutils "touch";
  xrandrBin = getExe' pkgs.xorg.xrandr "xrandr";
  awkBin = getExe' pkgs.gawk "awk";
  lockCmd = "${xlockBin} -echokeys";

  setBrightness = writeShellScript "xidlelock-set-brightness" ''
    mapfile -t screens < <(${xrandrBin} | ${awkBin} '/ connected/{print $1}')
    for out in "''${screens[@]}"; do
      ${xrandrBin} --output "$out" --brightness "$1"
    done
  '';
in {
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

  # handles systemd events (e.g. suspend)
  services.screen-locker = {
    enable = matchFor users.kotfind;
    lockCmd = lockCmd;
    xautolock.enable = false;
    inactiveInterval = 0; # disabled
  };

  systemd.user.services.lock-on-start = {
    Unit = {
      Description = "Lock screen on session start";
      After = [ "graphical-session.target" "xss-lock.service" ];
      ConditionPathExists = "!/tmp/lock-on-start-ran.lock";
    };
    Service = {
      Type = "oneshot";
      ExecStart = lockCmd;
      ExecStartPost = "${touchBin} /tmp/lock-on-start-ran.lock";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
