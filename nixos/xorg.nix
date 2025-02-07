{ cfg, ... }:
{
    services = {
        xserver = {
            enable = true;
            displayManager = {
                lightdm = {
                    enable = true;
                    greeter.enable = false;
                };
                defaultSession = "xsession";
                session = [{
                    manage = "desktop";
                    name = "xsession";
                    start = "exec $HOME/.session";
                }];
            };
        };

        displayManager.autoLogin = {
            enable = true;
            user = cfg.username;
        };
    };
}
