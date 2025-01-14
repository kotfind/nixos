{ ... }: {
    programs.alacritty.enable = true;

    home.file.".config/alacritty" = {
        source = ./.config/alacritty;
        recursive = true;
    };

    home.file."hello_2" = {
        source = ./.config/alacritty/alacritty.toml;
    };
}
