{ pkgs, config, ... }:
let
    desktop' = pkgName: desktopFileName: "${pkgs.${pkgName}}/share/applications/${desktopFileName}";
    desktop = pkgName: desktop' pkgName "${pkgName}.desktop";
in
{
    # FIXME: don't seem to work
    xdg.mimeApps = (with config.cfgLib; enableFor users.kotfind) {
        enable = true;
        defaultApplications =
            {
                "x-scheme-handler/tonsite" = desktop' "telegram-desktop" "org.telegram.desktop.desktop";
                "application/pdf" = desktop' "zathura" "org.pwmt.zathura-pdf-mupdf.desktop";
            }
            // (let
                sxiv = desktop "sxiv";
            in {
                "image/heif" = sxiv;
                "image/gif"  = sxiv;
                "image/png"  = sxiv;
                "image/jpeg" = sxiv;
            })
            // (let
                firefox = desktop "firefox";
            in { 
                "x-scheme-handler/http"  = firefox;
                "x-scheme-handler/https" = firefox;
                "text/html"              = firefox;
            });
    };
}
