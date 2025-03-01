{
  pkgs,
  config,
  ...
}: {
  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  # GnuPG
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-tty;
  };

  # Programs
  programs.light.enable = with config.cfgLib; matchFor hosts.laptop;
}
