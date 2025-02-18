{ config, ... }:
{
    programs.firefox = (with config.cfgLib; enableFor users.kotfind) {
        enable = true;

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
