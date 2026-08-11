{pkgs, config, ...}: let
  inherit (config.cfgLib) enableFor hosts;

  printerName = "HP_LaserJet_M1120_MFP";
in {
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      brlaser
      epson-escpr
      foomatic-db-ppds
      gutenprint
      hplip
    ];
  };

  hardware.printers = enableFor hosts.pc {
    ensureDefaultPrinter = printerName;
    ensurePrinters = [
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
  };
}
