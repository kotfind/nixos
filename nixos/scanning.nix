{pkgs, ...}: {
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.hplip];
  };

  # TODO: Using the scanner button
  # see: https://nixos.wiki/wiki/Scanners
}
