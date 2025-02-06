{
    left = /* fish */ ''
        set -l last_status $status

        # PWD
        set -l pwd (string replace $HOME \~ $PWD)
        set -l prompt_pwd (string split -- / $pwd | tail -n 2 | string join /)

        set_color $fish_color_cwd
        echo -n $prompt_pwd

        # Git
        set -g __fish_git_prompt_show_informative_status true
        set_color normal
        echo -n (fish_git_prompt)

        # Status
        if [ $last_status -ne 0 ]
            set_color --bold $fish_color_error
            echo -n " [$last_status]"
        end

        # Suffix
        set -l suffix "\$"
        if fish_is_root_user
            set suffix "#"
        end

        set_color normal
        echo -n " $suffix "
    '';

    right = /* fish */ ''
        # User and host
        set_color normal 
        echo -n (prompt_login)

        # Nix Shell
        if set -q IN_NIX_SHELL
            set_color $fish_color_cwd
            echo -n " [nix]"
        end

        set_color normal 
    '';
}
