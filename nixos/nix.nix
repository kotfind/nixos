{pkgs, ...}: {
  environment.sessionVariables.NIX_SOURCE = pkgs.path;
  nix.nixPath = ["nixpkgs=${pkgs.path}"];

  nix.channel.enable = false;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];

  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org?=100"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
