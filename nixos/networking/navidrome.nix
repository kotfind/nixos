{config, ...}: let
  inherit (config.cfgLib) matchFor hosts;
  inherit (config) sops;
in {
  services.navidrome = {
    enable = matchFor hosts.pc;

    user = "kotfind";
    group = "users";

    openFirewall = true;

    environmentFile = sops.secrets.navidromeEnvFile.path;

    settings = {
      Address = "0.0.0.0";

      MusicFolder = "/hdd/data/music/songs";
      DataFolder = "/hdd/data/music/navidrome";
      CacheFolder = "/var/cache/navidrome";

      LogLevel = "warn";

      DefaultTheme = "Light";

      ImageCacheSize = "1GB";
      TranscodingCacheSize = "5GB";
    };
  };

  sops.secrets.navidromeEnvFile = {
    sopsFile = ./navidrome.enc.env;
    format = "dotenv";
  };
}
