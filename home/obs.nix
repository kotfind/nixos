{ pkgs, ... }:
{
    programs.obs-studio = {
        enable = true;
        package = pkgs.obs-studio.override {
            ffmpeg = pkgs.ffmpeg-full.override {
                # Bag Fix
                # More info:
                # https://github.com/NixOS/nixpkgs/issues/368440
                # https://github.com/NixOS/nixpkgs/pull/369159
                withLcevcdec = false;
            };
            # TODO: doChecks = false;
        };
    };
}
