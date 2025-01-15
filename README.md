# Installation

Copy your hardware configuration:
```bash
cp /etc/nixos/hardware-configuration.nix ./nixos/hardware-configuration.nix
```

Define variables in `cfg.nix`:
```bash
nvim ./cfg.nix
```

Build and switch to configuration:
```
./switch
```
