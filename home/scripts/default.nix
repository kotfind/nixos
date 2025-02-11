{ pkgs, ... }:
{
    home.packages = [
        (import ./nolink.nix { inherit pkgs; })
    ];
}
