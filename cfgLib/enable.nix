{
  config,
  lib,
  ...
}: let
  inherit
    (config._cfgLib)
    moduleOpt
    isOfType
    ;

  isHost = isOfType "host";
  isUser = isOfType "user";
  isUserOnHost = isOfType "userOnHost";

  # Compares two objects, when both of them
  # are isHost, isUser, isUserOnHost
  eq = a: b:
    if isUser a && isUser b
    then a.name == b.name
    else if isHost a && isHost b
    then a.name == b.name
    else if isUserOnHost a && isUserOnHost b
    then eq a.host b.host && eq a.user b.user
    else throw "objects have either different or unsupported types";

  # Cfg is either isUserOnHost or isHost
  cfg = let
    userName = config.cfgLib.user.name or null;
    host = config.cfgLib.host;
  in
    if userName == null
    then host
    else if builtins.hasAttr userName host.users
    then host.users.${userName}
    else throw "user '${userName}' does not exist on host '${host.name}'";

  # Check if cfg matched restraint.
  # `cfg` should be either host or userOnHost.
  # if `cfg` is userOnHost then `restr` should be of one of these types: user, host or userOnHost.
  # if `cfg` is host then `restr` should be host.
  matchForSingle = restr:
    if isHost cfg
    then
      (
        if isHost restr
        then eq cfg restr
        else throw "restr has unsupported type: forgot to set config.user?"
      )
    else if isUserOnHost cfg
    then
      (
        if isUserOnHost restr
        then eq cfg restr
        else if isUser restr
        then eq cfg.user restr
        else if isHost restr
        then eq cfg.host restr
        else throw "restr has unsupported type"
      )
    else throw "cfg has unsupported type";

  # Returns true if cfg matches any of the restraints.
  matchForList = restrList:
    lib.lists.any
    matchForSingle
    restrList;

  matchFor = restr:
    if builtins.isList restr
    then matchForList restr
    else matchForSingle restr;

  enableFor = restr: var:
    lib.mkIf
    (matchFor restr)
    var;
in {
  options.cfgLib = {
    enableFor = lib.mkOption {
      type = moduleOpt (
        with lib.types;
          addCheck
          anything
          builtins.isFunction
      );
    };

    matchFor = lib.mkOption {
      type = moduleOpt (
        with lib.types;
          addCheck
          anything
          builtins.isFunction
      );
    };
  };

  config.cfgLib = {
    inherit enableFor matchFor;
  };
}
