{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) getExe;
  inherit (config.home) homeDirectory;
  inherit (config.cfgLib) enableFor users;

  x11vncBin = getExe pkgs.x11vnc;
in {
  # attaches to the running X session, localhost-only (connect via SSH tunnel)
  systemd.user.services.x11vnc = enableFor users.kotfind {
    Unit = {
      Description = "VNC server for the X session";
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${x11vncBin} -auth ${homeDirectory}/.Xauthority -display :0 -forever -shared -xrandr -localhost -nopw";
      Restart = "on-failure";
      RestartSec = "5";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
