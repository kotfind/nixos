{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.cfgLib) enableFor hosts;
  inherit (lib) getExe;
in {
  programs = {
    gallery-dl = enableFor hosts.pc.users.kotfind {
      enable = true;
    };

    yt-dlp = enableFor hosts.pc.users.kotfind {
      enable = true;
    };

    fish.shellAliases = enableFor hosts.pc.users.kotfind (with pkgs; {
      gdl = getExe gallery-dl;
      ydl = getExe yt-dlp;
    });
  };

  home.packages = enableFor hosts.pc.users.kotfind (with pkgs; [
    gdown
  ]);
}
