{ config, ... }:
{
    programs =  {
        gallery-dl = (with config.cfgLib; enableFor hosts.pc.users.kotfind) {
            enable = true;

            # TODO: auth
        };

        fish.shellAliases = (with config.cfgLib; enableFor hosts.pc.users.kotfind) {
            gdl = "gallery-dl";
        };
    };
}
