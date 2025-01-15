{ pkgs, cfg, ... }:
{
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = cfg.hostname;
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Moscow";

    i18n.defaultLocale = "en_US.UTF-8";
    console.useXkbConfig = true;

    services.xserver = {
        enable = true;
        displayManager.startx.enable = true;
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
    ];

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
        pinentryPackage = pkgs.pinentry-curses; 
    };

    programs.git.enable = true;

    services.openssh.enable = true;

    networking.firewall.enable = false;

    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings.General.Enable = "Source,Sink,Media,Socket";
    };

    services.blueman.enable = true;

    system.stateVersion = "24.11"; # DO NOT CHANGE
}
