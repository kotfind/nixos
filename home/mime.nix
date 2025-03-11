{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) readDir readFile attrNames length elemAt tryEval filter pathExists;
  inherit (config.cfgLib) matchFor users;
  inherit (getName) getName;
  inherit (lib.strings) concatMapStringsSep;
  inherit (lib) getExe;
  inherit (pkgs) makeDesktopItem;

  getDesktopDir = pkg: "${pkg}/share/applications";

  # checks if file is a regular file or a symlink, pointing to a regular file
  isRegularFile' = file: (tryEval (readFile file)).success;

  getDesktop = pkg: let
    dir = getDesktopDir pkg;
    files =
      filter
      (file: isRegularFile' "${dir}/${file}")
      (attrNames (readDir dir));
  in
    if length files == 0
    then throw "no desktop files found in '${dir}'"
    else if length files > 1
    then
      throw ("multiple desktop files found in '${dir}': [\n"
        + concatMapStringsSep "\n" (file: "  " + file) files
        + "\n]\nuse getDesktop' instead")
    else elemAt files 0;

  getDesktop' = pkg: file: let
    dir = getDesktopDir pkg;
    fullname = "${dir}/${file}";
  in
    if ! pathExists fullname
    then throw "file '${fullname}' does not exist"
    else if ! isRegularFile' fullname
    then throw "${fullname} is not a regular file"
    else file;

  openDirectoryDesktopFile = let
    alacrittyBin = getExe pkgs.alacritty;
  in
    makeDesktopItem {
      name = "open-directory";
      desktopName = "Open Directory";
      comment = "Opens directory in the Terminal";
      exec = "${alacrittyBin} --working-directory %f";
    };

  telegram = getDesktop pkgs.telegram-desktop;
  zathura-mupdf = getDesktop' pkgs.zathura "org.pwmt.zathura-pdf-mupdf.desktop";
  sxiv = getDesktop pkgs.sxiv;
  firefox = getDesktop pkgs.firefox;
  open-directory = getDesktop openDirectoryDesktopFile;
in {
  xdg.mimeApps = {
    enable = matchFor users.kotfind;

    # Learn file mime-type:
    #     file --mime-type $FILE
    #
    defaultApplications = {
      # images
      "image/gif" = sxiv;
      "image/heif" = sxiv;
      "image/jpeg" = sxiv;
      "image/png" = sxiv;

      # web
      "x-scheme-handler/http" = firefox;
      "x-scheme-handler/https" = firefox;
      "text/html" = firefox;

      # telegram links
      "x-scheme-handler/tonsite" = telegram;

      # directories
      "inode/directory" = open-directory;

      # pdfs
      "application/pdf" = zathura-mupdf;
    };
  };

  home.packages = [
    openDirectoryDesktopFile

    # mimeopen
    pkgs.perlPackages.FileMimeInfo
  ];
}
