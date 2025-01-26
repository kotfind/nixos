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
}
