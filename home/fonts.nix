{ pkgs, config, ... }:
{
    # List fonts:
    # fc-list : family style 
    fonts.fontconfig = (with config.cfgLib; enableFor users.kotfind) {
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

    home.packages = (with config.cfgLib; enableFor users.kotfind) (with pkgs; [
        ipafont
        kochi-substitute
        dejavu_fonts
        fira-code
        nerd-fonts.fira-code
    ]);
}
