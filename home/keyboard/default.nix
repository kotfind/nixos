{
  pkgs,
  config,
  ...
}: let
  inherit (config.cfgLib) users enableFor;

  dir = ".config/fcitx5";
in {
  home.file = enableFor users.kotfind {
    "${dir}/conf/xcb.conf".source = ./conf/xcb.conf;
    "${dir}/config" = {
      source = ./config;
      force = true;
    };
    "${dir}/profile" = {
      source = ./profile;
      force = true;
    };
  };

  i18n.inputMethod = enableFor users.kotfind {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-anthy
        fcitx5-gtk
      ];
    };
  };

  home.keyboard.options = ["caps:swapescape"];
}
