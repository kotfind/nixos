{
  pkgs,
  config,
  ...
}: let
  inherit (config.cfgLib) matchFor hosts;
in {
  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;

  # Keyboard
  console.useXkbConfig = true;
  i18n.defaultLocale = "en_US.UTF-8";
  services.libinput.enable = true;

  # Time Zone
  time.timeZone = "Europe/Moscow";

  # Man Pages
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
  ];

  documentation.dev.enable = true;

  # Security Agents
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-tty;
  };

  security.polkit.enable = true;

  # Programs
  programs.light.enable = matchFor hosts.laptop;

  # Virtual Camera plugin (for OBS Studio)
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
}
