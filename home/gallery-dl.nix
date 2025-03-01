{config, ...}: {
  programs = {
    gallery-dl = (with config.cfgLib; enableFor hosts.pc.users.kotfind) {
      enable = true;
    };

    fish.shellAliases = (with config.cfgLib; enableFor hosts.pc.users.kotfind) {
      gdl = "gallery-dl";
    };
  };
}
