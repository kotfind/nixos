{ pkgs, config, lib, ... }:
let
    autostartService = import ./autostart-service.nix { inherit lib; };
in
{
    imports = [
        ./bspwm.nix
        ./sxhkd.nix
        ./lemonbar.nix
    ];

    xsession = (with config.cfgLib; enableFor users.kotfind) {
        enable = true;
    };

    systemd.user.services.polkit = (with config.cfgLib; enableFor users.kotfind)
        (autostartService {
            cmd = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
        });

    services.batsignal = (with config.cfgLib; enableFor hosts.laptop.users.kotfind) {
        enable = true;
        extraArgs = [
            "-f" "99"
            "-w" "30"
            "-c" "10"
            "-d" "5"
            "-p"
        ];
    };

    services.gpg-agent = (with config.cfgLib; enableFor users.kotfind) {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        pinentryPackage = pkgs.pinentry-rofi;
    };

    services.screen-locker = (with config.cfgLib; enableFor users.kotfind) {
        enable = true;
        lockCmd = "${pkgs.xlockmore}/bin/xlock -echokeys";
    };

    home.sessionVariables = (with config.cfgLib; enableFor users.kotfind) {
        # for some java gui apps to work:
        _JAVA_AWT_WM_NONREPARENTING = 1;
    };

    systemd.user.tmpfiles.rules = (with config.cfgLib; enableFor users.kotfind)
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
