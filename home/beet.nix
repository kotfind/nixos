{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.hostlib) users join trueFor hosts;
  inherit (lib) genAttrs const pipe getExe;

  musicDir = "/home/kotfind/music";

  builtinPlugins = [
    "chroma"
    "convert"
    "deezer"
    "edit"
    "fetchart"
    "fromfilename"
    "lastgenre"
    "lyrics"
    "musicbrainz"
    "duplicates"
    "fuzzy"
    "info"
    "missing"
    "web"
  ];

  ffmpegBin = getExe pkgs.ffmpeg;
in {
  programs.beets = {
    enable = trueFor (join users.kotfind hosts.pc);

    package = pipe pkgs.python3.pkgs.beets [
      (it:
        it.overrideAttrs {
          doCheck = false;
          dontUsePytestCheck = true;
        })
      (it:
        it.override {
          pluginOverrides =
            genAttrs builtinPlugins
            <| const {enable = true;};
        })
    ];

    settings = {
      directory = "${musicDir}/songs";
      library = "${musicDir}/beets.db";
      path = "relative";

      terminal-encoding = "utf-8";

      threaded = true;

      ui.color = true;

      import = {
        write = true;
        copy = false;
        move = true;
      };

      convert = {
        auto = true;
        format = "mp3";
        formats = {
          mp3 = {
            command = "${ffmpegBin} -i $source -y -vn -b:a 192k $dest";
            extension = "mp3";
          };
        };
      };

      plugins = builtinPlugins;
    };
  };
}
