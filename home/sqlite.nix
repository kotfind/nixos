{
  config,
  pkgs,
  ...
}: {
  home.file.".sqliterc" = (with config.hostlib; mkFor users.kotfind) {
    text = ''
      .mode box
      .nullvalue ∅
    '';
  };

  home.packages = (with config.hostlib; mkFor users.kotfind) [
    pkgs.sqlite
  ];
}
