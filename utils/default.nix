{ pkgs, ... }:
rec {
    # Lists all regular files in current directory in format.
    # Paths in outputs are relative to current directory.
    # Note: `root` is usually `./.`
    listFilesRecursive =
        let
            helper = root: dir: 
                (pkgs.lib.mapAttrsToList
                    (name: type:
                        let
                            sep = if dir == "" then "" else "/";
                            fullname = "${dir}${sep}${name}";
                        in
                        if type == "regular"
                            then fullname
                            else helper root fullname
                    )
                    (builtins.readDir "${root}/${dir}")
                );
        in root: dir: pkgs.lib.flatten (helper root dir);

    toHomeFiles = dir: files: builtins.listToAttrs
        (builtins.map
            (path: {
                name = path;
                value = "${dir}/${path}";
            })
            files
        );

    toHomeFilesRec = root: dir: toHomeFiles dir (listFilesRecursive root dir);
}
