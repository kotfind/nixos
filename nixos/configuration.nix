{ pkgs, cfg, ... }:
{
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = cfg.hostname;
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Moscow";

    nix.nixPath = [
        "nixpkgs=${pkgs.path}"
    ];

    console.useXkbConfig = true;

    i18n.defaultLocale = "en_US.UTF-8";

    services.xserver = {
        enable = true;
        displayManager = {
            autoLogin = {
                enable = true;
                user = cfg.username;
            };
            lightdm = {
                enable = true;
                greeter.enable = false;
            };
            defaultSession = "xsession";
            session = [{
                manage = "desktop";
                name = "xsession";
                start = ''
                    exec $HOME/.session
                '';
            }];
        };
    };

    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
    };

    services.libinput.enable = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages = with pkgs; [
        podman-compose
        pavucontrol

        # more man pages:
        man-pages
        man-pages-posix
    ];

    # even more man pages
    documentation.dev.enable = true;

    virtualisation = {
        containers.enable = true;
        podman = {
            enable = true;
            dockerCompat = true;
            defaultNetwork.settings.dns_enabled = true;
        };
    };

    programs.gnupg.agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-rofi;
    };

    programs.git.enable = true;

    services.openssh = {
        enable = true;
        settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
        };
    };

    networking.firewall.enable = false;

    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings.General.Enable = "Source,Sink,Media,Socket";
    };

    services.blueman.enable = true;

    system.stateVersion = "24.11"; # DO NOT CHANGE
}
