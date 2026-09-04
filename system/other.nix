{
  pkgs,
  config,
  ...
}: {
  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;

  # Keyboard
  console.useXkbConfig = true;
  i18n.defaultLocale = "en_US.UTF-8";

  # Input
  services.libinput = {
    enable = true;
    # swap the forward/back side buttons (8 and 9)
    mouse.buttonMapping = "1 2 3 4 5 6 7 9 8 10 11 12";
  };

  services.udev.packages = [pkgs.brightnessctl];

  # Time Zone
  time.timeZone = "Europe/Moscow";

  # Documentation
  documentation = {
    enable = true;
    dev.enable = true;
    doc.enable = true;
    info.enable = true;
    man = {
      enable = true;
      cache.enable = true;
      man-db.enable = false;
      mandoc.enable = true;
    };
    nixos = {
      enable = true;
      includeAllModules = true;
    };
    # undocumented options fail the build
    nixos.options.warningsAreErrors = false;
  };

  # Security Agents
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-tty;
  };

  security.polkit.enable = true;

  # Dbus
  programs.dconf.enable = true;

  # Virtual Camera plugin (for OBS Studio)
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
}
