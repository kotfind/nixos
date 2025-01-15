{ cfg, ... }:
{
    # Note: don't forget `passwd`
    users.users.${cfg.username} = {
        isNormalUser = true;
        extraGroups = [
            "wheel"
            "networkmanager"
            "pipewire"
        ];
    };
}
