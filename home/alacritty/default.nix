{ pkgs, config, lib, ... }:
let
    activeThemeFile = "${config.home.homeDirectory}/.config/alacritty/active-theme.toml";

    toml = (pkgs.formats.toml {}).generate;

    themes = pkgs.lib.attrsets.mapAttrsToList
        (themeName: colors: toml "${themeName}.toml" { inherit colors; })
        (import ./themes.nix);

    themesStr = pkgs.lib.strings.concatMapStringsSep
        " "
        (themeFile: "'${themeFile}'")
        themes;

    toggleScript = pkgs.writeShellScript "alacritty-toggle-theme" ''
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
in
{
    programs.alacritty = {
        enable = true;
        settings = {
            general.import = [ activeThemeFile ];

            font.size = 11.0;

            window.padding = { x = 2; y = 2; };

            keyboard.bindings = [
                { mods = "Control|Shift"; key = "Return"; action = "SpawnNewInstance"; }
                { mods = "Control|Shift"; key = "n";      command = "${toggleScript}"; }
            ];
        };
    };

    home.activation.linkAlacrittyTheme = let
            themeFileArg = lib.escapeShellArg (builtins.elemAt themes 0);
            activeThemeFileArg = lib.escapeShellArg activeThemeFile;
        in
        config.lib.dag.entryAfter ["writeBoundary"]
            /* bash */ ''
                # create directory if it does not exist
                mkdir -p $(dirname ${activeThemeFileArg})

                # link theme file
                ln -sf ${themeFileArg} ${activeThemeFileArg}
            '';
}
