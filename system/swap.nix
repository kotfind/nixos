{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.hostlib) hosts mkFor;
  inherit (lib) getExe';

  freeBin = getExe' pkgs.procps "free";
  awkBin = getExe' pkgs.gawk "awk";
  swapoffBin = getExe' pkgs.util-linux "swapoff";
  swaponBin = getExe' pkgs.util-linux "swapon";
in {
  # Prefer keeping pages in RAM over swapping.
  boot.kernel.sysctl = mkFor hosts.pc {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
  };

  swapDevices = mkFor hosts.pc [
    {
      device = lib.mkForce "/var/swapfile";
      label = "swapfile";
      size = 64 * 1024; # 64 GB
    }
  ];

  systemd.services.empty-swap = mkFor hosts.pc {
    description = "Empty swap when at least half of memory is available";
    serviceConfig.Type = "oneshot";
    script = ''
      total=$(${freeBin} -b | ${awkBin} '/^Mem:/ {print $2}')
      available=$(${freeBin} -b | ${awkBin} '/^Mem:/ {print $NF}')
      swap_used=$(${freeBin} -b | ${awkBin} '/^Swap:/ {print $3}')

      threshold=$((total * 50 / 100))

      if [ "$swap_used" -gt 0 ] && [ "$available" -ge "$threshold" ]; then
        ${swapoffBin} -a && ${swaponBin} -a
      fi
    '';
  };

  systemd.timers.empty-swap = mkFor hosts.pc {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "1min";
    };
  };
}
