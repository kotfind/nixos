{
  config,
  lib,
  ...
}: let
  inherit (builtins) listToAttrs;
  inherit (lib.strings) concatMapStringsSep;
  inherit (config) cfgLib;

  users = with cfgLib.users; [
    kotfind
  ];

  # Run `lsusb` from `usbutils`:
  #     nix shell nixpkgs#usbutils -c lsusb
  #
  # Parse output:
  #     ID 2717:ff88
  # means
  #     { idVendor = 2717; idProduct = ff88; }
  devices = [
    {
      idVendor = "2717";
      idProduct = "ff88";
    }
  ];

  androidGroups = [
    "adbusers"
    "kvm"
  ];
in {
  users.users = listToAttrs (map
    (user: {
      name = user.name;
      value = {
        extraGroups = androidGroups;
      };
    })
    users);

  users.groups = listToAttrs (
    map
    (group: {
      name = group;
      value = {};
    })
    androidGroups
  );

  services.udev.extraRules =
    concatMapStringsSep
    "\n"
    ({
      idVendor,
      idProduct,
    }: ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="${idVendor}", MODE="[]", GROUP="adbusers", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTR{idVendor}=="${idVendor}", ATTR{idProduct}=="${idProduct}", SYMLINK+="android_adb"
      SUBSYSTEM=="usb", ATTR{idVendor}=="${idVendor}", ATTR{idProduct}=="${idProduct}", SYMLINK+="android_fastboot"
    '')
    devices;
}
