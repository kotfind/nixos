{pkgs, ...}: {
  virtualisation = {
    containers.enable = true;
    oci-containers.backend = "podman";

    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    docker = {
      enable = true;
      enableOnBoot = true;
    };
  };

  environment.systemPackages = with pkgs; [
    podman-compose
  ];

  environment.sessionVariables = {
    PODMAN_COMPOSE_WARNING_LOGS = "false";
  };

  # Fix podman
  nixpkgs.overlays = [
    (final: prev: {
      podman = prev.podman.override {
        extraPackages = [
          # https://github.com/NixOS/nixpkgs/issues/138423#issuecomment-1609849179
          "/run/wrappers/"

          pkgs.shadow
        ];
      };
    })
  ];
}
