# Installation

1. Copy your hardware configuration:
    ```bash
    cp /etc/nixos/hardware-configuration.nix ./nixos/hardware-configuration.nix
    ```

2. Define current host in `current-host.nix`:
    ```bash
    nvim ./cfg.nix
    ```

    Example configuration:
    ```nix
    hosts: hosts.pc
    ```

3. Build and switch to configuration:
    ```bash
    nix run .#switch
    ```

4. Set user passwords:
    ```bash
    passwd *USERNAME*
    ```

# Note on switch and update

Bot `nixos-rebuild switch` and `nixos-rebuild update` should NOT be executed manualy, but
through the wrappers:
```bash
nix run .#switch
```
and
```bash
nix run .#update
```
