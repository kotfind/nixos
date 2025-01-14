{ pkgs, ... }:
{
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "kotfindPC";
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Moscow";

    # networking.proxy.default = "http://127.0.0.1:1010";
    # networking.proxy.noProxy = "127.0.0.1,localhost";

    console.useXkbConfig = true;
    i18n = {
        defaultLocale = "en_US.UTF-8";

        inputMethod = {
            type = "fcitx5";
            enable = true;
            fcitx5.addons = with pkgs; [
                fcitx5-anthy
                fcitx5-gtk
            ];
        };
    };


    services.xserver = {
        enable = true;
        windowManager.bspwm.enable = true;
        displayManager.startx.enable = true;
    };

    services.xserver.xkb = {
        layout = "us,ru";
        options = "caps:swapescape,grp:alt_shift_toggle";
    };

    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
    };

    services.libinput.enable = true;

    # Note: don't forget `passwd`
    users.users.kotfind = {
    # users.users.${cfg.username} = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
    };

    programs.neovim = {
        enable = true;
        defaultEditor = true;
        vimAlias = true;
        viAlias = true;
        withNodeJs = true;
    };

    programs.firefox.enable = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages = with pkgs; [
        shadowsocks-rust
        nekoray
        tmux
        vlc
        vlc-bittorrent
        gh
        wget
        curl
        fd
        ripgrep
        htop
        rustc
        cargo
        openssl
        pkg-config
        podman-compose
        pass
        telegram-desktop
        xclip # for nvim
        killall
        rofi
        sxhkd
        lemonbar-xft
        xtitle # for lemonbar
        trayer # for lemonbar
        lxqt.lxqt-policykit
        pavucontrol
        alacritty
        sxiv
        gallery-dl
        imagemagick
        gcc
        unzip # for nvim
        cached-nix-shell
        scrot
        eza
        jq
    ];

    # List fonts:
    # fc-list : family style 
    fonts = {
        # enableDefaultPackages = true;
        packages = with pkgs; [
            ipafont
                kochi-substitute
                dejavu_fonts
                font-awesome
        ];
        fontconfig.defaultFonts = {
            monospace = [
                "DejaVu Sans Mono"
                "IPAGothic"
                "Font Awesome 6 Free"
                "Font Awesome 6 Brands"
            ];
            sansSerif = [
                "DejaVu Sans"
                "IPAPGothic"
            ];
            serif = [
                "DejaVu Serif"
                "IPAPMincho"
            ];
        };
    };

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
        settings = {
            General = {
                Enable = "Source,Sink,Media,Socket";
            };
        };
    };

    services.blueman.enable = true;

    # system.copySystemConfiguration = true;

    system.stateVersion = "24.11"; # DO NOT CHANGE
}

