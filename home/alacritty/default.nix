{ pkgs, config, ... }:
let
    activeThemeFileName = "active-theme.toml";
    activeThemeFile = "${config.home.homeDirectory}/.config/alacritty/${activeThemeFileName}";

    themesDir = ./themes;
    defaultTheme = "dark.toml";

    toggleScript = pkgs.writeShellScriptBin "alacritty-toggle-theme" ''
        set -euo pipefail
        set -x

        themes=(${themesDir}/*.toml)
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
            general.import = [ activeThemeFileName ];

            font.size = 11.0;

            window.padding = { x = 2; y = 2; };

            keyboard.bindings = [
                { mods = "Control|Shift"; key = "Return"; action = "SpawnNewInstance"; }
                { mods = "Control|Shift"; key = "n";      command = "${toggleScript}/bin/alacritty-toggle-theme"; }
            ];
        };
    };

    home.activation.linkAlacrittyTheme = config.lib.dag.entryAfter ["writeBoundary"] ''
        ln -sf ${themesDir}/${defaultTheme} ${activeThemeFile}
    '';
}
