{
  config,
  pkgs,
  lib,
  ...
}: {
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
    gnutar
    cloc
  ];

  programs = {
    man.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
    jq.enable = true;
    htop.enable = true;
  };

  programs.direnv = (with config.cfgLib; enableFor users.kotfind) {
    enable = true;

    nix-direnv.enable = true;
  };

  programs.fish.shellAliases."j" = lib.getExe pkgs.just;
}
