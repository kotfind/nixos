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
    ```
    ./switch
    ```
