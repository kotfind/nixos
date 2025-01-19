# Dummy
if not status is-interactive
    exit 0
end

# # TODO: move to nix bash config
# # Start X at login
# if status is-login
#     if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
#         exec startx -- -keeptty
#     end
# end

# Reset abbreviations
set -g fish_user_abbreviations

# Aliases
alias p3 'python3'
alias e 'exec'

# Eza aliases
alias ls 'eza --group-directories-first --color=always --git-ignore'
alias l  'eza --group-directories-first --color=always --git-ignore -hl'
alias L  'eza --group-directories-first --color=always -ahl'
alias t  'eza --group-directories-first --color=always --tree --git-ignore -hl'
alias T  'eza --group-directories-first --color=always --tree -ahl'

# Git Aliases
alias gs 'git status --short'
alias ga 'git add'
alias gc 'git commit'
alias gca 'git commit --amend'
alias gp 'git push'
alias gd 'git diff --word-diff=color'
alias gdc 'git diff --cached --word-diff=color'
alias gl 'git log --oneline'
alias gt 'git log --graph --all --oneline --decorate'
alias gch 'git checkout'
alias gb 'git branch'
alias gm 'git merge'

alias root 'cd (git rev-parse --show-toplevel)'

# Path aliases
for i in (seq 3 10)
    alias (string repeat -n$i '.')="cd $(string repeat -n (math $i - 1) '../')"
end

# Prompt
function fish_prompt
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
        echo -n ' ['$last_status']'
    end

    # Suffix
    set -l suffix "\$"
    if fish_is_root_user
        set suffix "#"
    end

    set_color normal
    echo -n ' '$suffix' '
end

function fish_right_prompt
    set_color normal
    echo -n (prompt_login)
    set_color normal
end


# Disable greeting and not_found
function fish_command_not_found
    __fish_default_command_not_found_handler $argv
end

function fish_greeting
end

# Custom commands
function mkcd -a dir
    mkdir -p $dir &&
    cd $dir
end

function tempcd
    set dir (mktemp -d)
    echo $dir
    cd $dir
end

function nsh
    cached-nix-shell default.nix --run "fish"
end
