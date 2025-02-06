{ pkgs, ... }:
let
    dir = ".config/fcitx5";
in
{
    home.file = {
        "${dir}/conf/xcb.conf".source = ./conf/xcb.conf;
        "${dir}/config".source = ./config;
        "${dir}/profile".source = ./profile;
    };

    i18n.inputMethod = {
        enabled = "fcitx5";
        fcitx5 = {
            addons = with pkgs; [
                fcitx5-anthy
                fcitx5-gtk
            ];
        };
    };

    home.keyboard.options = [ "caps:swapescape" ];
}
