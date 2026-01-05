{pkgs, ...}: let
  printerName = "HP_LaserJet_M1120_MFP";
in {
  services.printing = {
    enable = true;
    drivers = [pkgs.hplipWithPlugin];
  };

  hardware.printers.ensureDefaultPrinter = printerName;
  hardware.printers.ensurePrinters = [
    {
      name = printerName;
      deviceUri = "usb://HP/LaserJet%20M1120%20MFP?serial=MF28T32&interface=1";
      model = "HP/hp-laserjet_m1120_mfp.ppd.gz";
      ppdOptions = {
        PageSize = "A4";
        Double-Sided = "None";
      };
    }
  ];
}
