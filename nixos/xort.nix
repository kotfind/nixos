{ cfg, ... }:
{
    services.xserver = {
        enable = true;
        displayManager = {
            autoLogin = {
                enable = true;
                user = cfg.username;
            };
            lightdm = {
                enable = true;
                greeter.enable = false;
            };
            defaultSession = "xsession";
            session = [{
                manage = "desktop";
                name = "xsession";
                start = ''
                    exec $HOME/.session
                '';
            }];
        };
    };
}
