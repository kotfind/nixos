{
  config,
  lib,
  ...
}: let
  inherit (config.hostlib) mkFor users hosts;
in {
  users.users."${users.kotfind.name}" = {
    isNormalUser = true;
    linger = true;
    extraGroups = lib.mkMerge [
      [
        "wheel"
        "networkmanager"
        "pipewire"
        "docker"
        "dialout" # for arduino & rpi pico
        "scanner"
        "lp" # printing
      ]
      (mkFor hosts.laptop [
        "video" # for light command
      ])
      (mkFor hosts.pc [
        "libvirtd"
      ])
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhQ4XOorlM4E5mHrPcwp76WcFUeyjAkWQwMLNDZMlIV kotfind@kotfindPC"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCQE4U6vQqMt/tLugQdHDH8It7Um1nbCalW/15N4OradKxuaaegXBUjCnxbAXiVZxSIEzOa/Wm9pTzQP4yY5QhlWJUs4DvZhK1SsHEsVenuDo3q8nxN5iVqPUZas8ve3/safMTldJAYpuN1ElfX3GT1I/nzMTRAZZ+z1Qw0dmDV9qm213DoNFMW5HWGXDmhZUJAWHVu6FzJu24iUzDKMZYsLF20JqkrIHL4zuPU/ssneWSVM+/gnjMjP87HZ3k+f6iOivIjxkd1EaSyo1eS4SLyNhGc+HQt4m9xqToM704VdyVhGvQi56Ys2wDzv560jH5nQiATjOYAr9m3QnoE+gQOx4GsB+SoR0Y6iTwL1Hry88cWZm1/DZ/MNH4lpKusrzTMmGbzak0N6VdBvz2gk/qj4blg1+3d6roEBAYxrMfcM1WKdmjZHZmgfPBaOWesaRbKzj4Cf1YSJy5kXISpIkwg7CP25EFvcZ8K9XmJaUVbzFFU8KjnKddiaW1hfbjAo0k= kotfind@kotfindLT"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBOWD+50iZD/6fdy078XUqcp8RQ9Ys6VCSnBwBwdGTao chubiy@work"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIID3Ursx1MBB/NKjLoIhgKHJk4BTpr8gNS/xXnIhrP1y kotfind@haven"
    ];
  };

  nix.settings.trusted-users = [
    "@wheel"
  ];
}
