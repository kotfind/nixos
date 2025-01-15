{ pkgs, ... }:
{
    programs = {
        fish = {
            enable = true;
            interactiveShellInit = builtins.readFile ./.config/fish/config.fish;
        };
        eza.enable = true;
        yazi = {
            enable = true;
            enableFishIntegration = true;
        };
    };

    # fish as a default interactive shell
    programs.bash = {
        enable = true;
        bashrcExtra = ''
            # from https://wiki.archlinux.org/title/Fish#Modify_.bashrc_to_drop_into_fish
            if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]; then
               shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
               exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
            fi
        '';
    };
}
