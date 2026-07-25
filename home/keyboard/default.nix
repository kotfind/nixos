{
  pkgs,
  config,
  inputs,
  system,
  ...
}: let
  inherit (config.cfgLib) users enableFor;
  inherit (inputs.fcitx5-ilo-sitelen.packages.${system}) fcitx5-ilo-sitelen;
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
      addons = with pkgs;
        [
          fcitx5-anthy
          fcitx5-gtk
        ]
        ++ [
          fcitx5-ilo-sitelen
        ];
    };
  };

  # required for .desktop apps to work
  systemd.user.sessionVariables = {
    QT_IM_MODULE = "fcitx";
    GTK_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
  };

  home.keyboard.options = ["caps:swapescape"];
}
