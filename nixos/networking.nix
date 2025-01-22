{ cfg, ... }: {
    networking = {
        hostName = cfg.hostname;

        networkmanager.enable = true;

        firewall.enable = false;
    };
}
