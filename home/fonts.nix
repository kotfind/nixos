{
  pkgs,
  config,
  inputs,
  system,
  ...
}: let
  inherit (config.cfgLib) enableFor users;
  inherit (inputs.nasin-nanpa.packages.${system}) nasin-nanpa-font-4-UCSUR;
in {
  # List fonts:
  # fc-list : family style
  fonts.fontconfig = enableFor users.kotfind {
    enable = true;
    defaultFonts = {
      monospace = [
        "FiraCode" # default
        "IPAGothic" # Japanese
        "FiraCode Nerd Font Mono" # icons
      ];
      sansSerif = [
        "DejaVu Sans" # default
        "IPAPGothic" # Japanese
        "nasin-nanpa" # Toki Pona
      ];
      serif = [
        "DejaVu Serif" # default
        "IPAPMincho" # Japanese
        "nasin-nanpa" # Toki Pona
      ];
    };
  };

  home.packages = enableFor users.kotfind (with pkgs; [
    ipafont
    kochi-substitute
    dejavu_fonts
    fira-code
    nerd-fonts.fira-code
    nasin-nanpa-font-4-UCSUR
  ]);
}
