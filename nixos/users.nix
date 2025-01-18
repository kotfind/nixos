{ cfg, ... }:
{
    # Note: don't forget `passwd`
    users.users.${cfg.username} = {
        isNormalUser = true;
        extraGroups = [
            "wheel"
            "networkmanager"
            "pipewire"
        ];
        openssh.authorizedKeys.keys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9oPp6GpHJ6LgpyuV5k1JkyJba+HY8rgzmzkCkfpRuAQHBx4pI3i2L5YtQtkRK7ZlNhP9B7b1RWxvRNIby8MkgQ+i1903IKNeRk6t0crTt6Gvv2NFAmvBzttAMyvgJjvby5kelA5QfcmX1EgZAk3zfGkDN3kf2l8ZQGeZCn7hy8UeCYeTt/nuGusi3BL4sIqSbwRAI+BZjEzZobOUVERzbjRzu9x8h3k51CBO9e2qVRzBy7ixm9P+1Np/Ud85z5E//JF4eutNewLWT3bblAq78Ene3jD0K8YBWydJ0qxLwB0Dzop1+X5dQOm1NjoTsMxBRU9FaWUwBBhzI5dq56R7V5x/R+60XI2We5voagPI8p4C1CocMkjPUhmeQJdjPrWM43nnYXZf25uH25TLReBV2CLNPjp1UwJ/pv6l4fvisevUdGeIs4X1FNdkIdYzxLJoMhCkkiJ0osX+5nE4k5eRDajO+7/5P8L8fNks4qXqz4dNtkkQ1Uu7y9jYQhvpaikMj66C2nbFYHdTmpFuFj2W02jXJBNyz5Y12jPDitUvzi3vgyOM7WgQhHlHGl5EdwxOGrkDhzWTlRmymavP/PzvPXjNnAMbb7IWTINvi++F9Q0Ul0dzunX+bu5r9Jjabw3olicnF5X92Rd2zW1q0o2SJdWXglguMQHctRXjr/85duw== JuiceSSH"
        ];
    };
}
