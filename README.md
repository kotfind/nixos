# Install

## Create bootable USB

1. Download nixos *minimal* ISO image:

    <https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso>

1. Create a bootable USB with [Ventoy](https://www.ventoy.net/en/doc_start.html):

    ```bash
    sudo ventoy -I /dev/sdX
    sudo mount /dev/sdX1 /mnt
    sudo cp latest-nixos-minimal-x86_64-linux.iso /mnt
    sudo umount /mnt
    ```

## Install

1. Load from bootable USB

1. Check the internet connection:

    ```bash
    ping 8.8.8.8
    ```

1. Change to `root`:

    ```bash
    sudo -i
    ```

1. Partition a drive:

    `fdisk`, GPT table

    | *Device*    | *Size* | *Type*                |
    | :---------  | -----: | :-------------------  |
    | `/dev/sdX1` |   512M | EFI Sytem (1)         |
    | `/dev/sdX2` |   32G  | Linux swap (19)       |
    | `/dev/sdX3` |   ...  | Linux filesystem (20) |

1. Format partitions:

    ```bash
    mkfs.vfat -F32 /dev/sdX1
    mkswap /dev/sdX2
    mkfs.ext4 /dev/sdX3
    ```

1. Mount partitions:

    ```bash
    mount /dev/sdX3 /mnt
    mkdir -p /mnt/boot
    mount -o umask=077 /dev/sdX1 /mnt/boot
    swapon /dev/sdX2
    ```

1. Clone this repo

    ```bash
    git clone https://github.com/kotfind/nixos /root/nixos
    ```

1. Generate `hardware-configuration.nix`:

    ```bash
    nixos-generate-config --root /mnt --dir /tmp
    mv /tmp/hardware-configuration.nix /root/nixos/nixos
    cd /root/nixos
    ```

1. Define current host in `current-host.nix`:

    ```bash
    nvim ./cfg.nix
    ```

    Example configuration:

    ```nix
    hosts: hosts.pc
    ```

1. Ignore local files in git:

    ```bash
    git update-index --skip-worktree current-host.nix nixos/hardware-configuration.nix
    ```

1. Install:

    ```bash
    cd /root/nixos
    nixos-install --flake .#default --verbose
    ```

1. Move configuration dir to `kotfind` user:

    ```bash
    mv /root/nixos /mnt/home/kotfind/nixos
    nixos-enter --root /mnt -c 'chown -R kotfind:users /home/kotfind/nixos'
    ```

1. Set password for `kotfind`:

    ```bash
    nixos-enter --root /mnt -c 'passwd kotfind'
    ```

1. Reboot

    ```bash
    reboot
    ```

1. Switch to configuration

    ```bash
    cd ~/nixos
    sudo nixos-rebuild switch --flake .#default
    ```
