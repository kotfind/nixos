# not a module, just a function to be dirrectly included
{ lib }:
{
    cmd,
    packages ? [],
    isOneshot ? false,
    remainAfterExit ? isOneshot,
} : {
    Install = {
        WantedBy = [ "graphical-session.target" ];
    };

    Service = {
        ExecStart = cmd;

        Environment = [
            "PATH=${
                lib.escapeShellArg
                    (lib.strings.makeBinPath packages)
            }"
        ];

        RemainAfterExit = remainAfterExit;

        Type = if isOneshot then "oneshot" else "simple";
    };

    Unit = {
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
    };
}
