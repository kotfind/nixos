{ pkgs, config, ... }:
let
    dir = ".config/fcitx5";
in
{
    home.file = (with config.cfgLib; enableFor users.kotfind) {
        "${dir}/conf/xcb.conf".source = ./conf/xcb.conf;
        "${dir}/config".source = ./config;
        "${dir}/profile".source = ./profile;
    };

    i18n.inputMethod = (with config.cfgLib; enableFor users.kotfind) { enabled = "fcitx5";
        fcitx5 = {
            addons = with pkgs; [
                fcitx5-anthy
                fcitx5-gtk
            ];
        };
    };

    home.keyboard.options = [ "caps:swapescape" ];
}
