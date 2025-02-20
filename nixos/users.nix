{ config, ... }:
{
    users.users."${config.cfgLib.users.kotfind.name}" = {
        isNormalUser = true;
        linger = true;
        extraGroups = [
            "wheel"
            "networkmanager"
            "pipewire"
        ];
        openssh.authorizedKeys.keys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9oPp6GpHJ6LgpyuV5k1JkyJba+HY8rgzmzkCkfpRuAQHBx4pI3i2L5YtQtkRK7ZlNhP9B7b1RWxvRNIby8MkgQ+i1903IKNeRk6t0crTt6Gvv2NFAmvBzttAMyvgJjvby5kelA5QfcmX1EgZAk3zfGkDN3kf2l8ZQGeZCn7hy8UeCYeTt/nuGusi3BL4sIqSbwRAI+BZjEzZobOUVERzbjRzu9x8h3k51CBO9e2qVRzBy7ixm9P+1Np/Ud85z5E//JF4eutNewLWT3bblAq78Ene3jD0K8YBWydJ0qxLwB0Dzop1+X5dQOm1NjoTsMxBRU9FaWUwBBhzI5dq56R7V5x/R+60XI2We5voagPI8p4C1CocMkjPUhmeQJdjPrWM43nnYXZf25uH25TLReBV2CLNPjp1UwJ/pv6l4fvisevUdGeIs4X1FNdkIdYzxLJoMhCkkiJ0osX+5nE4k5eRDajO+7/5P8L8fNks4qXqz4dNtkkQ1Uu7y9jYQhvpaikMj66C2nbFYHdTmpFuFj2W02jXJBNyz5Y12jPDitUvzi3vgyOM7WgQhHlHGl5EdwxOGrkDhzWTlRmymavP/PzvPXjNnAMbb7IWTINvi++F9Q0Ul0dzunX+bu5r9Jjabw3olicnF5X92Rd2zW1q0o2SJdWXglguMQHctRXjr/85duw== JuiceSSH"
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCQE4U6vQqMt/tLugQdHDH8It7Um1nbCalW/15N4OradKxuaaegXBUjCnxbAXiVZxSIEzOa/Wm9pTzQP4yY5QhlWJUs4DvZhK1SsHEsVenuDo3q8nxN5iVqPUZas8ve3/safMTldJAYpuN1ElfX3GT1I/nzMTRAZZ+z1Qw0dmDV9qm213DoNFMW5HWGXDmhZUJAWHVu6FzJu24iUzDKMZYsLF20JqkrIHL4zuPU/ssneWSVM+/gnjMjP87HZ3k+f6iOivIjxkd1EaSyo1eS4SLyNhGc+HQt4m9xqToM704VdyVhGvQi56Ys2wDzv560jH5nQiATjOYAr9m3QnoE+gQOx4GsB+SoR0Y6iTwL1Hry88cWZm1/DZ/MNH4lpKusrzTMmGbzak0N6VdBvz2gk/qj4blg1+3d6roEBAYxrMfcM1WKdmjZHZmgfPBaOWesaRbKzj4Cf1YSJy5kXISpIkwg7CP25EFvcZ8K9XmJaUVbzFFU8KjnKddiaW1hfbjAo0k= kotfind@kotfindLT"
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqXAoR6gqLUkYGpkVBkGgSDjyv68niEhXfxV05inIBiwMoYkIR6XsClUiFEx7uo97khEUOcol4qu4LxJVUURjQBdJN5cqKPTheCyCZoKSPe565YUqV9E55k528MkAfIi2Qz+XAmwr4ZEBFGECZQdI2WcrE1VgSVzxW9/YjDIcTgzkN7P4f3GiZnWb+sD8tJL+HAoMJ6HoaM/O0ghkWN1iKjwEp9Nh9QRuMwwpCvGqJy/GUdmjRy+YbVWe64pGEAge1dB/Wl/fbKdncUZ7m568/s9f9we3hQ/XEYGmxCMhRrV8CXYVlqc+5QKViRfgEiNPYE0/tqQhRP4NaOKHqxRveG+3oISCayxbDjAUzH0iH0uMohZTgGbPcGcwlDJHszD9YwISOlZfHrErsSXf63fK9MuQvj76LK4q6o6wCrlRC3550eWYGD03nME9TQKemnp2kVFgml/kUPwI6hPq0pHFYIXyvdsp/FrwbRgq79BesQ7ZOvWno+if7CxNbn6VfmOs= kotfind@kotfindPC"
        ];
    };

    nix.settings.trusted-users = [
        "@wheel"
    ];
}
