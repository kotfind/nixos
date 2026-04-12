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
    xkill
    ncdu
    killall
    file
    imagemagick
    ffmpeg
    age
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
    xh
    ueberzugpp # for yazi image preview
    sshpass
    dig
    claude-code

    wineWow64Packages.stable # TODO: move to other file?
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

  programs.bash.shellAliases = {
    "unrar" = getExe pkgs.unrar-free;
  };

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
  };
}
