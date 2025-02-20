{ ... }:
{
    services.openssh = {
        enable = true;
        settings = {
            X11Forwarding = true;
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
        };
    };

    programs = {
        mosh = {
            enable = true;
        };

        ssh = {
            setXAuthLocation = true;
            forwardX11 = true;
        };
    };
}
