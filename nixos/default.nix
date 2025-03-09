{...}: {
  imports = [
    {system.stateVersion = "24.11";}

    ./hardware-configuration.nix

    ./android.nix
    ./audio.nix
    ./bluetooth.nix
    ./networking.nix
    ./nix.nix
    ./other.nix
    ./services.nix
    ./ssh.nix
    ./users.nix
    ./virtualization.nix
    ./xorg.nix
  ];
}
