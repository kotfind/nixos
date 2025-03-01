# This value is passed to outputs.apps.${system}
{
  nixpkgs,
  system,
  ...
}: let
  # -------------------- Basic Setup --------------------
  pkgs = import nixpkgs {inherit system;};
  lib = pkgs.lib;

  modules = lib.evalModules {
    specialArgs = {inherit pkgs lib;};
    modules = [
      ./profiles.nix
    ];
  };

  users = modules.config.cfgLib.users;

  # -------------------- Dependencies --------------------

  nixos-rebuild = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";

  # -------------------- Other --------------------

  mkApp = script: {
    type = "app";
    program = lib.getExe script;
  };

  # Goes to path "$1", relative to flake root
  dirFromRoot = pkgs.writeShellScriptBin "dir-from-root" ''
    set -euo pipefail

    while true; do
        if [ -e 'flake.nix' ]; then
            flake_root="$PWD"
            break
        fi

        if [ "$PWD" -ef "/" ]; then
            echo 'flake.nix was not found in current or parent directories' 1>&2
            exit 1
        fi

        cd ..
    done

    path="$flake_root/$1"

    if [ ! -d "$path" ]; then
        echo "$path is not a directory" 1>&2
        exit 1
    fi

    echo "$path"
  '';

  dirRoot = pkgs.writeShellScriptBin "dir-root" ''
    ${lib.getExe dirFromRoot} .
  '';

  switch = pkgs.writeShellScriptBin "switch" ''
    set -euo pipefail

    pushd "$(${lib.getExe dirRoot})"

    sudo -v

    sudo ${nixos-rebuild} switch --flake .#default --verbose

    ${
      lib.strings.concatMapStrings
      (userName_: let
        userName = lib.escapeShellArg userName_;
      in
        /*
        bash
        */
        ''
          echo -e "\n-------------------- activate ${userName} --------------------\n"

          gen="$(awk '/ExecStart=/ { print $2; }' /etc/systemd/system/home-manager-${userName}.service)"

          rm -f "/home/${userName}/.config/fcitx5/profile"
          rm -f "/home/${userName}/.config/fcitx5/config"

          sudo -u "${userName}" "$gen/activate"
        '')
      (builtins.attrNames users)
    }

    popd
  '';

  update = pkgs.writeShellScriptBin "update" ''
    set -euo pipefail

    pushd "$(${lib.getExe dirRoot})"

    sudo -v

    sudo nix flake update

    ${lib.getExe (import ./home/nvim/update.nix {
      inherit pkgs lib users dirFromRoot;
    })}

    popd

    ${lib.getExe switch}
  '';
in {
  switch = mkApp switch;
  update = mkApp update;
}
