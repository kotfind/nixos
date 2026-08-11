{pkgs, ...}: {
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.hplipWithPlugin];
  };

  # TODO: Using the scanner button
  # see: https://nixos.wiki/wiki/Scanners
}
