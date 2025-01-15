{ ... }: {
    programs.alacritty.enable = true;

    home.file.".config/alacritty" = {
        source = ./.config/alacritty;
        recursive = true;
    };
}
