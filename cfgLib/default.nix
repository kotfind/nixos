{lib, ...}: {
  imports = [
    ./host.nix
    ./user.nix
    ./utils.nix
    ./enable.nix
  ];

  options = {
    _cfgLib = lib.mkOption {
      type = with lib.types; attrsOf anything;
    };
  };
}
