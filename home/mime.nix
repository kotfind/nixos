{config, ...}: let
  telegram = "org.telegram.desktop.desktop";
  zathura = "org.pwmt.zathura-pdf-mupdf.desktop";
  sxiv = "sxiv.desktop";
  firefox = "firefox.desktop";
in {
  xdg.mimeApps = (with config.cfgLib; enableFor users.kotfind) {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/tonsite" = telegram;
      "application/pdf" = zathura;
      "image/heif" = sxiv;
      "image/gif" = sxiv;
      "image/png" = sxiv;
      "image/jpeg" = sxiv;
      "x-scheme-handler/http" = firefox;
      "x-scheme-handler/https" = firefox;
      "text/html" = firefox;
    };
  };
}
