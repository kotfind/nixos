{ cfg, ... }:
{
    programs.password-store = {
        enable = true;
        settings = {
            # it's not the default for whatever reason
            PASSWORD_STORE_DIR = "/home/${cfg.username}/.password-store";
        };
    };

    # TODO: auto clone
    # TODO: rofi integration
}
