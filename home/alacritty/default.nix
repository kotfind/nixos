{ ... }: {
    programs.alacritty.enable = true;

    home.file.".config/alacritty/alacritty.toml".source = ./.config/alacritty/alacritty.toml;
    home.file.".config/alacritty/dark_theme.toml".source = ./.config/alacritty/dark_theme.toml;
    home.file.".config/alacritty/light_theme.toml".source = ./.config/alacritty/light_theme.toml;
}
