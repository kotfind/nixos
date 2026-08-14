{config, ...}: let
  inherit (config.xdg) configHome;
in {
  programs.firefox = (with config.cfgLib; enableFor users.kotfind) {
    enable = true;
    configPath = "${configHome}/mozilla/firefox";

    # docs: https://mozilla.github.io/policy-templates
    policies = {
      DisplayBookmarksToolbar = "never";
      DisplayMenuBar = "never";
      DownloadDirectory = "/tmp/downloads";
      PDFjs = "false";
      # Proxy = "...";
      # TODO: toolbar: synched tabs, downloads
    };

    # TODO: profiles
  };
}
