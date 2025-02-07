{ pkgs, ... }:
{
    # List fonts:
    # fc-list : family style 
    fonts.fontconfig = {
        enable = true;
        defaultFonts = {
            monospace = [
                "FiraCode"
                "IPAGothic"
                "FiraCode Nerd Font Mono"
            ];
            sansSerif = [
                "DejaVu Sans"
                "IPAPGothic"
            ];
            serif = [
                "DejaVu Serif"
                "IPAPMincho"
            ];
        };
    };

    home.packages = with pkgs; [
        ipafont
        kochi-substitute
        dejavu_fonts
        fira-code
        nerd-fonts.fira-code
    ];
}
