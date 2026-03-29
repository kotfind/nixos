{...}: {
  imports = [
    ./blesh.nix
    ./funcs.nix
    ./general.nix
    ./starship.nix
  ];

  programs.bash.enable = true;
}
