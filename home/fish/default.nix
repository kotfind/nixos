{...}: {
  imports = [
    ./funcs.nix
    ./prompt.nix
    ./aliases.nix
    ./interactive.nix
  ];

  programs.fish. enable = true;
}
