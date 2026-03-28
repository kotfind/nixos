{...}: {
  imports = [
    ./blesh.nix
    ./starship.nix
    ./general.nix
  ];

  programs.bash.enable = true;
}
