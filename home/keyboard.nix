{ pkgs, ... }:
{
    # i18n.inputMethod = {
    #     enabled = "fcitx5";
    #     fcitx5.addons = with pkgs; [
    #         fcitx5-anthy
    #         fcitx5-gtk
    #     ];
    # };

    home.packages = with pkgs; [
        fcitx5
        fcitx5-gtk
        fcitx5-anthy
    ];

    home.sessionVariables = {
        XMODIFIERS="@im=fcitx";
        XMODIFIER="@im=fcitx";
        GTK_IM_MODULE="fcitx";
        QT_IM_MODULE="fcitx";
    };

    xsession.enable = true;
    home.keyboard = {
        layout = "us,ru";
        options = [
            "caps:swapescape"
            "grp:alt_shift_toggle"
            "grp_led:scroll"
        ];
    };
}
