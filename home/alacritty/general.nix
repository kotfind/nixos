{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) getExe escapeShellArg;
  inherit (lib.strings) concatMapStringsSep;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (pkgs) writeShellScript;
  inherit (config.cfgLib) enableFor hosts;
  inherit (config.home) homeDirectory;

  activeThemeFile = "${homeDirectory}/.config/alacritty/active-theme.toml";

  toml = (pkgs.formats.toml {}).generate;

  themes =
    mapAttrsToList
    (themeName: colors: toml "${themeName}.toml" {inherit colors;})
    (import ./themes.nix);

  themesStr =
    concatMapStringsSep
    " "
    (themeFile: "'${themeFile}'")
    themes;

  toggleScript = writeShellScript "alacritty-toggle-theme" ''
    set -euo pipefail
    set -x

    themes=(${themesStr})
    themes+=("''${themes[0]}")

    for i in "''${!themes[@]}"; do
        if [ "${activeThemeFile}" -ef "''${themes["$i"]}" ]; then
            ln -sf ''${themes[$((i + 1))]} ${activeThemeFile}
            exit
        fi
    done

    echo "failed to toggle theme" 1>&2
    exit 1
  '';
in {
  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell = getExe pkgs.bash;

      general.import = [activeThemeFile];

      font.size = lib.mkMerge [
        (enableFor hosts.pc 11.0)
        (enableFor hosts.laptop 8.0)
      ];

      window.padding = {
        x = 2;
        y = 2;
      };

      keyboard.bindings = [
        {
          mods = "Control|Shift";
          key = "Return";
          action = "SpawnNewInstance";
        }
        {
          mods = "Control|Shift";
          key = "n";
          command = "${toggleScript}";
        }
      ];
    };
  };

  home.activation.linkAlacrittyTheme = let
    themeFileArg = escapeShellArg (builtins.elemAt themes 0);
    activeThemeFileArg = escapeShellArg activeThemeFile;
  in
    config.lib.dag.entryAfter ["writeBoundary"] ''
      mkdir -p $(dirname ${activeThemeFileArg})
      ln -sf ${themeFileArg} ${activeThemeFileArg}
    '';
}
