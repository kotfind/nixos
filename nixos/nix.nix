{pkgs, ...}: {
  environment.sessionVariables.NIX_SOURCE = pkgs.path;
  nix.nixPath = ["nixpkgs=${pkgs.path}"];

  nix.channel.enable = false;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];
}
