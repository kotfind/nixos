{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.hostlib) join trueFor mkFor users hosts;

  userName = config.hostlib._curUser.name;
  homeDir = config.home.homeDirectory;
in {
  xsession.enable = trueFor users.kotfind;

  services.lxqt-policykit-agent.enable = trueFor users.kotfind;

  services.network-manager-applet.enable = trueFor users.kotfind;

  services.picom.enable = trueFor users.kotfind;

  services.batsignal = {
    enable = trueFor (join users.kotfind hosts.laptop);
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
    enable = trueFor users.kotfind;
    pinentry.package = pkgs.pinentry-rofi;
  };

  # for some java gui apps to work:
  home.sessionVariables._JAVA_AWT_WM_NONREPARENTING = 1;

  systemd.user.tmpfiles.rules =
    mkFor users.kotfind
    [
      # Type  Path                  Mode  User         Group   Age  Argument
      "d      /tmp/downloads        0755  ${userName}  users   -    -"
      "d      /tmp/screenshots      0755  ${userName}  users   -    -"
      "L+     ${homeDir}/Downloads  -     -            -       -    /tmp/downloads"
    ];
}
