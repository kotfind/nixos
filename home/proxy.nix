{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs;
    lib.mkMerge [
      [
        shadowsocks-rust
      ]

      ((with config.cfgLib; enableFor users.kotfind) [
        nekoray
      ])
    ];
}
