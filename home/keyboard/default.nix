{
  pkgs,
  config,
  ...
}: let
  inherit (config.cfgLib) users enableFor;
in {
  home.file = enableFor users.kotfind {
    ".config/fcitx5" = {
      source = ./config;
      force = true;
      recursive = true;
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
