{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.strings) fixedWidthString concatMapStringsSep;

  spaces = n: fixedWidthString n " " "";
  parser = lang: "${pkgs.tree-sitter.builtGrammars.${"tree-sitter-${lang}"}}/parser";

  lang = name: indent: exts: ''
    {
      grammar.source.path = "${parser name}",
      extensions = [${concatMapStringsSep ", " (ext: "\"${ext}\"") exts}],
      indent = "${spaces indent}",
    }
  '';
in {
  home.packages = with pkgs; [
    topiary
  ];

  home.file.".config/topiary/languages.ncl".text = ''
    {
      languages | force = {
        elm = ${lang "elm" 4 ["elm"]},
      },
    }
  '';

  home.file.".config/topiary/queries".source = ./queries;
}
