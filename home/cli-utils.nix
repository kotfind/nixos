{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe;
in {
  home.packages = with pkgs; [
    wget
    curl
    bat
    xclip
    xorg.xkill
    ncdu
    killall
    file
    imagemagick
    ffmpeg
    age
    just
    p7zip
    unzip
    unrar-free
    gnutar
    cloc
    binutils
    jpegoptim
    ascii
    usbutils
    poppler-utils # for pdftotext
    python3

    wineWowPackages.stable # TODO: move to other file?
  ];

  programs = {
    man.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
    jq.enable = true;
    htop.enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fish.shellAliases = {
    "j" = getExe pkgs.just;
    "unrar" = getExe pkgs.unrar-free;
  };
}
