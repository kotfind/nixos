{ cfg, pkgs, ... }:
{
    home.packages = with pkgs; [
        wget
        curl
        killall
        cached-nix-shell
        p7zip
        imagemagick
    ];

    programs = {
        man.enable = true;
        fd.enable = true;
        ripgrep.enable = true;
        jq.enable = true;

        git = {
            enable = true;
            userName = cfg.username;
            userEmail = cfg.email;

            # TODO: add keys
        };

        gh = {
            enable = true;
            settings.git_protocol = "ssh";
        };

        htop = {
            enable = true;

            # TODO: configure
        };
    };
}
