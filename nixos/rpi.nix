{lib, ...}: let
  inherit (lib.strings) concatMapStringsSep;

  idProducts = [
    "0003"
    "0009"
    "000a"
    "000f"
  ];
in {
  services.udev.extraRules =
    concatMapStringsSep
    "\n"
    (idProduct: ''
      SUBSYSTEM=="usb", \
      ATTRS{idVendor}=="2e8a", \
      ATTRS{idProduct}=="${idProduct}", \
      TAG+="uaccess", \
      MODE="660", \
      GROUP="dialout"
    '')
    idProducts;
}
