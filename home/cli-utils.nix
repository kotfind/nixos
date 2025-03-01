{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs;
    lib.mkMerge [
      [
        wget
        curl
        killall
        p7zip
        bat
        ncdu
        file
        xclip
        cloc
        imagemagick
        ffmpeg
        age
        just
      ]
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

  programs.fish.shellAliases."j" = "just";
}
