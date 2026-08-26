{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.hostlib) users join mkFor hosts;
  inherit (lib) getExe;
in {
  programs = {
    gallery-dl = mkFor (join users.kotfind hosts.pc) {
      enable = true;
    };

    yt-dlp = mkFor (join users.kotfind hosts.pc) {
      enable = true;
    };

    bash.shellAliases = mkFor (join users.kotfind hosts.pc) (with pkgs; {
      gdl = getExe gallery-dl;
      ydl = getExe yt-dlp;
    });
  };

  home.packages = mkFor (join users.kotfind hosts.pc) (with pkgs; [
    gdown
  ]);
}
