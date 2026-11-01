{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  inherit (pkgs.rustPlatform) buildRustPackage;
  inherit (lib.licenses) mit;
  inherit (config.hostlib) hosts mkFor;

  src = inputs.svg2gcode;

  svg2gcode = buildRustPackage {
    pname = "svg2gcode";
    version = "0.0.18";
    inherit src;
    cargoLock.lockFile = "${src}/Cargo.lock";
    meta = {
      description = "Convert SVG paths to GCode for CNC machines, laser engravers, and plotters";
      homepage = "https://github.com/sameer/svg2gcode";
      license = mit;
      mainProgram = "svg2gcode";
    };
  };
in {
  home.packages = mkFor hosts.pc [svg2gcode];
}
