{ pkgs, ... }:
{
    programs.neovim = {
        enable = true;
        defaultEditor = true;
        vimAlias = true;
        vimdiffAlias = true;
        viAlias = true;
        withNodeJs = true; # delete me
    };

    home.file.".config/nvim" = {
        source = ./.config/nvim;
        recursive = true;
    };

    home.packages = with pkgs; [
        unzip # TODO: delete me
        xclip
    ];
}
