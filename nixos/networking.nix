{ config, ... }: {
    networking = {
        hostName = config.cfgLib.host.data.hostname;

        networkmanager.enable = true;

        firewall.enable = false;
    };
}
