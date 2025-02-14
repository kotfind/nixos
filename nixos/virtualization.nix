{ pkgs, ... }:
{
    virtualisation = {
        containers.enable = true;
        oci-containers.backend = "podman";

        podman = {
            enable = true;
            dockerCompat = true;
            defaultNetwork.settings.dns_enabled = true;
        };
    };

    environment.systemPackages = with pkgs; [
        podman-compose
    ];

    # Fix podman
    nixpkgs.overlays = [ (final: prev: {
        podman = prev.podman.override {
            extraPackages = [
                # https://github.com/NixOS/nixpkgs/issues/138423#issuecomment-1609849179
                "/run/wrappers/"

                pkgs.shadow
            ];
        };
    }) ];
}
