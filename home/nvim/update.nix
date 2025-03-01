# this is not a nixosConfigurations module, it's included from apps.nix
{
  pkgs,
  lib,
  dirFromRoot,
  users,
  ...
}: let
  bash = "${pkgs.runtimeShell}";
  nvim = "${pkgs.neovim}/bin/nvim";
  unlink = "${pkgs.toybox}/bin/unlink";
  touch = "${pkgs.toybox}/bin/touch";
  ln = "${pkgs.toybox}/bin/ln";

  updateUser = userName:
  /*
  bash
  */
  ''
    set -euo pipefail

    echo -e "\n-------------------- updating nvim plugins for ${userName} --------------------\n"

    homeDir="$(eval echo "~${userName}")"

    # real lock file, used by nvim
    real_lock_file="$homeDir/.config/nvim/lazy-lock.json"

    # local lock file, stored in config
    local_lock_file="$PWD/lazy-lock/${userName}.json"

    if [ ! -e "$local_lock_file" ]; then
        ${touch} "$local_lock_file"
    fi

    # make real_lock_file point to local_lock_file, not to readonly /nix/store
    if [ -L "$real_lock_file" ]; then
        ${unlink} "$real_lock_file"
    fi

    # check if real_lock_file is a regular file
    if [ -f "$real_lock_file" ]; then
        echo "error: $real_lock_file is a regular file (no a symlink)" 2>&1
        exit 1
    fi

    ${ln} -s "$local_lock_file" "$real_lock_file"

    # update lock file
    ${nvim} \
        --headless \
        -c ':Lazy! sync' \
        -c ':Lazy! load nvim-treesitter' \
        -c ':TSInstallSync all' \
        -c ':TSUpdateSync' \
        -c qa

    # remove real_lock_file, so it could be created by home-manager
    ${unlink} "$real_lock_file"
  '';
in
  pkgs.writeShellApplication {
    name = "update-nvim-lazy-lock";

    runtimeInputs = with pkgs; [
      gcc
      gnumake
    ];

    text = ''
      set -euo pipefail

      pushd "$(${lib.getExe dirFromRoot} home/nvim)"

      ${
        lib.concatMapStrings
        (
          userName_: let
            userName = lib.escapeShellArg userName_;
          in
            /*
            bash
            */
            ''
              sudo -u ${userName} \
                  ${bash} -c ${lib.escapeShellArg (updateUser userName)}
            ''
        )
        (builtins.attrNames users)
      }

      popd
    '';
  }
