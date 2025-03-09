{
  pkgs,
  config,
  lib,
  ...
}: let
  users = with config.cfgLib.users; [
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
in {
  users.users = builtins.listToAttrs (builtins.map
    (user: {
      name = user.name;
      value = {
        extraGroups = [
          "adbusers"
          "kvm"
        ];
      };
    })
    users);

  services.udev.packages = with pkgs; [
    android-udev-rules
  ];

  services.udev.extraRules =
    lib.strings.concatMapStringsSep
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
