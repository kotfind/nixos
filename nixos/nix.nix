{pkgs, ...}: {
  nix.nixPath = [
    "nixpkgs=${pkgs.path}"
  ];

  environment.sessionVariables = {
    NIX_SOURCE = pkgs.path;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
