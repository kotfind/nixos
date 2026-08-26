{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.hostlib) users join trueFor hosts;
  inherit (lib) genAttrs const;

  builtinPlugins = [
    "chroma"
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
in {
  programs.beets = {
    enable = trueFor (join users.kotfind hosts.pc);

    package = lib.pipe pkgs.python3.pkgs.beets [
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
      directory = "/hdd/data/music/songs";
      library = "/hdd/data/music/beet/beet.db";
      path = "relative";

      terminal-encoding = "utf-8";

      threaded = true;

      ui.color = true;

      import = {
        write = true;
        copy = false;
        move = true;
      };

      plugins = builtinPlugins;
    };
  };
}
