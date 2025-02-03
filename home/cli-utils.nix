{ cfg, pkgs, ... }:
{
    home.packages = with pkgs; [
        wget
        curl
        killall
        cached-nix-shell
        p7zip
        imagemagick
        gh
        ncdu
        bat
        file
        ffmpeg
        cloc
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

            extraConfig = {
                core.quotepath = false;
            };

            difftastic.enable = true;
        };

        # TODO: fixme
        # gh = {
        #     enable = true;
        #     settings.git_protocol = "ssh";
        # };

        htop = {
            enable = true;

            # TODO: configure
        };

        direnv = {
            enable = true;
            nix-direnv.enable = true;
        };
    };
}
