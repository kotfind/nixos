{...}: {
  imports = [
    ./blesh
    ./funcs.nix
    ./general.nix
    ./starship.nix
  ];

  programs.bash.enable = true;
}
