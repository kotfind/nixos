# This value is passed to outputs.apps.${system}

{ nixpkgs, system, ... }:
let
    # -------------------- Basic Setup --------------------
    pkgs = import nixpkgs { inherit system; };
    lib = pkgs.lib;

    modules = lib.evalModules {
        specialArgs = { inherit pkgs lib; };
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
        program = "${script}";
    };

    assertRoot = pkgs.writeShellScript "assert-root" ''
        if [ ! -e 'flake.nix' ]; then
            echo 'please run this script from flake root directory' 1>&2
            exit 1
        fi
    '';

    switch = pkgs.writeShellScript "switch" ''
        set -euo pipefail

        ${assertRoot}

        sudo ${nixos-rebuild} switch --flake .#default --verbose

        ${lib.strings.concatMapStrings
            (userName_: let
                    userName = lib.escapeShellArg userName_;
                in
                /* bash */ ''
                    echo "-------------------- activate ${userName} --------------------"

                    gen="$(awk '/ExecStart=/ { print $2; }' /etc/systemd/system/home-manager-${userName}.service)"

                    rm -f "/home/${userName}/.config/fcitx5/profile"
                    rm -f "/home/${userName}/.config/fcitx5/config"

                    sudo -u "${userName}" "$gen/activate"
                '')
            (builtins.attrNames users)
        }
    '';
in
{
    switch = mkApp switch;
}
