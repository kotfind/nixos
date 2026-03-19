{lib, ...}: let
  inherit (lib.strings) concatMapStringsSep concatStringsSep;

  # -------------------- Rpi --------------------

  rpiVendorId = "2e8a";
  rpiProductIds = [
    "0003"
    "0009"
    "000a"
    "000f"
  ];

  rpiRules =
    concatMapStringsSep
    "\n"
    (productId: ''
      SUBSYSTEM=="usb", \
      ATTRS{idVendor}=="${rpiVendorId}", \
      ATTRS{idProduct}=="${productId}", \
      TAG+="uaccess", \
      MODE="660", \
      GROUP="dialout"
    '')
    rpiProductIds;

  # -------------------- Custom Device --------------------

  customDeviceVendorId = "c0de";
  customDeviceProductId = "cafe";

  customDeviceRules = ''
    SUBSYSTEM=="usb", \
    ATTR{idVendor}=="${customDeviceVendorId}", \
    ATTR{idProduct}=="${customDeviceProductId}", \
    GROUP="plugdev", \
    MODE="0660"
  '';
in {
  services.udev.extraRules = concatStringsSep "\n" [
    rpiRules
    customDeviceRules
  ];
}
