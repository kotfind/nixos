{
  config,
  lib,
  ...
}: let
  inherit (config.hostlib) trueFor hosts;
  inherit (config) sops;

  musicDir = "/home/kotfind/music";
in {
  services.navidrome = {
    enable = trueFor hosts.pc;

    user = "kotfind";
    group = "users";

    openFirewall = true;

    environmentFile = sops.secrets.navidromeEnvFile.path;

    settings = {
      Address = "0.0.0.0";

      MusicFolder = "${musicDir}/songs";
      DataFolder = "${musicDir}/navidrome";
      CacheFolder = "/var/cache/navidrome";

      LogLevel = "warn";

      DefaultTheme = "Light";

      ImageCacheSize = "1GB";
      TranscodingCacheSize = "5GB";
    };
  };

  systemd.services.navidrome.serviceConfig.ProtectHome = lib.mkForce false;

  sops.secrets.navidromeEnvFile = {
    sopsFile = ./navidrome.enc.env;
    format = "dotenv";
  };
}
