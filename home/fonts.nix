{ pkgs, ... }:
{
    # List fonts:
    # fc-list : family style 
    fonts.fontconfig = {
        enable = true;
        defaultFonts = {
            monospace = [
                "DejaVu Sans Mono"
                "IPAGothic"
                "Font Awesome 6 Free"
                "Font Awesome 6 Brands"
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
        font-awesome
    ];
}
