{ ... }: {
    programs.alacritty.enable = true;

    home.file.".config/alacritty" = {
        source = ./.config/alacritty;
        recursive = true;
    };

    home.file."hello_10" = {
        text = ''
            #!/usr/bin/env bash
            echo "hello_10"
        '';
        executable = true;
    };
}
