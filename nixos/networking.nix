{ ... }: {
    networking = {
        # FIXME
        # hostName = cfg.hostname;
        hostName = "kotfindPC";

        networkmanager.enable = true;

        firewall.enable = false;
    };
}
