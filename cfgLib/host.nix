{ lib, config, ... }:
let
    inherit (config._cfgLib)
        userType
        attrsOfNamed
        moduleOpt
        isOfType;

    isHost = isOfType "host";

    hostDefType = lib.types.submodule {
        options = {
            users = lib.mkOption {
                type = lib.types.listOf userType;
            };

            data = lib.mkOption {
                type = lib.types.anything;
                default = null;
            };
        };
    };

    mapHost = hostName: hostData: lib.fix
        (host: {
            type = "host";
            name = hostName;
            inherit (hostData) data;
            users = builtins.listToAttrs (builtins.map
                (user: {
                    name = user.name;
                    value = {
                        type = "userOnHost";
                        inherit user host;
                    };
                })
                hostData.users
            );
        });

    hosts = lib.attrsets.mapAttrs
        mapHost
        config.cfgLib.hostsDef;
in
{
    options.cfgLib = {
        hosts = lib.mkOption {
            type = moduleOpt
                (with lib.types; attrsOf anything);

            example = {
                pc = {
                    type = "host";
                    # same as attr name
                    name = "pc";
                    users = {
                        user1 = {
                            type = "userOnHost";
                            user = /* user from config.users */ {};
                            host = /* pc (this host) */ {};
                        };
                    };
                    # custom user data
                    data = {
                        hostname = "myPC";
                    };
                };
            };
        };

        hostsDef = lib.mkOption {
            type = attrsOfNamed hostDefType;

            example = {
                pc = {
                    users = [ /* users */ ];
                    data = {
                        hostname = "myPC";
                    };
                };
            };
        };

        host = lib.mkOption {
            # rescursive types don't seem to work
            type = with lib.types; addCheck
                anything
                isHost;

            description = "current host";
        };
    };

    config.cfgLib = {
        inherit hosts;
    };
}
