{ ... }:
{
    imports = [
        { system.stateVersion = "24.11"; }

        ./audio.nix
        ./bluetooth.nix
        ./hardware-configuration.nix
        ./networking.nix
        ./nix.nix
        ./other.nix
        ./services.nix
        ./ssh.nix
        ./users.nix
        ./virtualization.nix
        ./xort.nix
    ];
}
