{...}: {
  imports = [
    {system.stateVersion = "24.11";}

    ./hardware-configuration.nix

    ./android.nix
    ./audio.nix
    ./bluetooth.nix
    ./networking
    ./nix.nix
    ./other.nix
    ./printing.nix
    ./rpi.nix
    ./scanning.nix
    ./services.nix
    ./ssh.nix
    ./sunshine.nix
    ./users.nix
    ./virtualization.nix
    ./xorg.nix
  ];
}
