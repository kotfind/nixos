{ pkgs, ... }:
{
    nix.nixPath = [
        "nixpkgs=${pkgs.path}"
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
