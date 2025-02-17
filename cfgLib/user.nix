{ lib, config, ... }:
let
    inherit (config._cfgLib)
        exactStr
        attrsOfNamed
        moduleOpt
        isOfType;

    isUser = isOfType "user";

    userType = lib.types.submodule {
        options = {
            type = lib.mkOption {
                type = exactStr "user";
            };

            name = lib.mkOption {
                type = lib.types.str;
            };

            data = lib.mkOption {
                type = lib.types.anything;
                default = {};
            };
        };
    };

    users = lib.attrsets.mapAttrs
        (username: userData: {
            type = "user";
            name = username;
            data = userData;
        })
        config.cfgLib.usersDef;
in
{
    options.cfgLib = {
        users = lib.mkOption {
            type = moduleOpt (attrsOfNamed userType);

            example = {
                user1 = {
                    type = "user";
                    # same as attr name 
                    name = "user1";
                    # custom user data
                    data = {
                        email = "user@example.org";
                    };
                };
            };
        };

        usersDef = lib.mkOption {
            type = with lib.types; attrsOf anything;

            example = {
                user = {
                    email = "user@example.org";
                };
                root = {
                    homeDir = "/root";
                };
            };
        };

        user = lib.mkOption {
            type = moduleOpt
                (with lib.types; nullOr
                    (addCheck
                        anything
                        isUser
                    )
                );

            description = "current user";
        };
    };

    config.cfgLib = {
        inherit users;

        user = let
                userName = config.home.username or null;
            in
            if userName == null
                then null
                else config.cfgLib.host.users.${userName}.user or null;
    };

    config._cfgLib = {
        inherit userType;
    };
}
