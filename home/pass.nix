{ config, ... }:
{
    programs = {
        password-store = (with config.cfgLib; enableFor users.kotfind) {
            enable = true;
            settings = {
                # it's not the default for whatever reason
                PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
            };
        };

        rofi.pass = (with config.cfgLib; enableFor users.kotfind) {
            enable = true;
            extraConfig = ''
                default_do='typePass'
            '';
        };
    };

    # TODO: auto clone (activation script?)
}
