{
  pkgs,
  config,
  lib,
  ...
}: let
  autostartService = import ./autostart-service.nix {inherit lib;};

  inherit (config.cfgLib) matchFor enableFor users hosts;
  inherit (lib) getExe getExe';
in {
  imports = [
    ./bspwm.nix
    ./sxhkd.nix
    ./lemonbar.nix
    ./dunst.nix
    ./picom.nix
  ];

  xsession.enable = matchFor users.kotfind;

  systemd.user.services.polkit = enableFor users.kotfind (autostartService {
    cmd = getExe' pkgs.lxqt.lxqt-policykit "lxqt-policykit-agent";
  });

  # install networkmanagerapplet for all hosts, but autostart in on the laptop only
  systemd.user.services.network-manager-applet = enableFor hosts.laptop.users.kotfind (autostartService {
    cmd = getExe pkgs.networkmanagerapplet;
  });

  home.packages = enableFor users.kotfind (with pkgs; [
    networkmanagerapplet
  ]);

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
    enableFishIntegration = true;
    enableBashIntegration = true;
    pinentry.package = pkgs.pinentry-rofi;
  };

  services.screen-locker = {
    enable = matchFor users.kotfind;
    lockCmd = "${getExe' pkgs.xlockmore "xlock"} -echokeys";
  };

  home.sessionVariables = enableFor users.kotfind {
    # for some java gui apps to work:
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  systemd.user.tmpfiles.rules =
    enableFor users.kotfind
    (let
      user = config.cfgLib.user.name;
      home = config.home.homeDirectory;
    in [
      # Type  Path               Mode  User     Group   Age  Argument
      "d      /tmp/downloads     0755  ${user}  users   -    -"
      "d      /tmp/screenshots   0755  ${user}  users   -    -"
      "L+     ${home}/Downloads  -     -        -       -    /tmp/downloads"
    ]);
}
