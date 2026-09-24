{pkgs, ...}: {
  environment.sessionVariables.NIX_SOURCE = pkgs.path;
  nix.nixPath = ["nixpkgs=${pkgs.path}"];

  nix.channel.enable = false;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];

  nix.gc = {
    automatic = true;
    dates = ["16:00"];
    options = "--delete-older-than 30d";
  };
}
