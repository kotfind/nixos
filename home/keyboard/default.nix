{ pkgs, ... }:
{
    home.file.".config/fcitx5/conf/xcb.conf".source = ./.config/fcitx5/conf/xcb.conf;
    home.file.".config/fcitx5/config".source = ./.config/fcitx5/config;
    home.file.".config/fcitx5/profile".source = ./.config/fcitx5/profile;

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
