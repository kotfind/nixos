{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    gallery-dl = (with config.cfgLib; enableFor hosts.pc.users.kotfind) {
      enable = true;
    };

    yt-dlp = (with config.cfgLib; enableFor hosts.pc.users.kotfind) {
      enable = true;
    };

    fish.shellAliases = (with config.cfgLib; enableFor hosts.pc.users.kotfind) {
      gdl = lib.getExe pkgs.gallery-dl;
      ydl = lib.getExe pkgs.yt-dlp;
    };
  };

  home.packages = (with config.cfgLib; enableFor hosts.pc.users.kotfind) (with pkgs; [
    gdown
  ]);
}
