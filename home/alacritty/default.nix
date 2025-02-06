{ pkgs, config, ... }:
let
    themes = [
        ./.config/alacritty/dark_theme.toml
        ./.config/alacritty/light_theme.toml
    ];

    themesStr = pkgs.lib.strings.concatMapStringsSep
        " "
        (theme: "'${theme}'")
        themes;

    dir = ".config/alacritty";
    absDir = "${config.home.homeDirectory}/${dir}";
    themeFile = "${absDir}/theme.toml";
in
{
    programs.alacritty.enable = true;

    home.file."${dir}/alacritty.toml".source = ./.config/alacritty/alacritty.toml;
    home.file."${dir}/toggle_theme.sh" = {
        executable = true;
        text = /* bash */ ''
            #!${pkgs.bash}/bin/bash

            set -euo pipefail
            set -x

            THEMES=(${themesStr})
            THEMES+=("''${THEMES[0]}")

            for i in "''${!THEMES[@]}"; do
                if [ "${themeFile}" -ef "''${THEMES["$i"]}" ]; then
                    ln -sf ''${THEMES[$((i + 1))]} ${themeFile}
                    exit
                fi
            done

            echo "failed to toggle theme" 1>&2
            exit 1
        '';
    };

    home.activation.linkAlacrittyTheme = config.lib.dag.entryAfter ["writeBoundary"] ''
        ln -sf ${builtins.elemAt themes 0} ${themeFile}
    '';
}
