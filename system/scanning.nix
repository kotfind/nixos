{pkgs, ...}: {
  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [
      hplipWithPlugin
      sane-airscan
    ];
  };

  # TODO: Using the scanner button
  # see: https://nixos.wiki/wiki/Scanners
}
