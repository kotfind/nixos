{ pkgs, ... }:
{
    home.packages = with pkgs; [
        gh
        wget
        curl
        fd
        ripgrep
        htop
        xclip
        killall
        cached-nix-shell
        jq
        p7zip
        imagemagick
    ];
}
