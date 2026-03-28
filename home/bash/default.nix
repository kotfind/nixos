{...}: {
  imports = [
    ./blesh.nix
    ./general.nix
    ./starship.nix
  ];

  programs.bash.enable = true;
}
