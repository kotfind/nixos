{ pkgs, ... }:
{
    toHomeFiles =
        let 
            listFilesRecursiveHelper = root: dir: 
                (pkgs.lib.mapAttrsToList
                    (name: type:
                        let
                            fullname = "${dir}/${name}";
                        in
                        if type == "regular"
                            then fullname
                            else listFilesRecursiveHelper root fullname
                    )
                    (builtins.readDir "${root}/${dir}")
                );

            listFilesRecursive = root: pkgs.lib.flatten (listFilesRecursiveHelper root ".");

            toHomeFiles = dir: builtins.listToAttrs
                (builtins.map
                    (path: {
                        name = path;
                        value = "${dir}/${path}";
                    })
                    (listFilesRecursive dir)
                );
        in toHomeFiles;
}
