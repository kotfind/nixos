{
  pkgs,
  inputs,
  lib,
  system,
  ...
}:
# TODO?: don't install lsp servers for root?
let
  inherit (builtins) isString isList isAttrs;
  inherit (lib) getExe';
  inherit (lib.strings) escape concatMapStringsSep concatMapAttrsStringSep;

  toLua = v:
    if v == null
    then "nil"
    else if isString v
    then "'" + escape ["'" "\\"] v + "'"
    else if isList v
    then "{" + concatMapStringsSep "," toLua v + "}"
    else if isAttrs v
    then "{" + concatMapAttrsStringSep "," (name: value: name + "=" + toLua value) v + "}"
    else throw "cannot convert to lua";

  codeium-lsp = inputs.codeium.packages.${system}.codeium-lsp;

  packages = with pkgs;
    [
      xclip
      websocat
    ]
    ++ [codeium-lsp];

  formatters = with pkgs; [
    alejandra
    stylua
    typstyle
  ];

  lspServers = with pkgs; [
    nixd
    lua-language-server
    tinymist
  ];
in {
  programs.neovim = {
    enable = true;

    defaultEditor = true;

    vimAlias = true;
    vimdiffAlias = true;
    viAlias = true;

    withNodeJs = true;
    withPython3 = false;
    withRuby = false;

    extraPackages = packages ++ formatters ++ lspServers;

    extraLuaConfig =
      /*
      lua
      */
      ''
        -- this file was generatred by nix

        -- Export some variables
        CodeiumPath = '${getExe' codeium-lsp "codeium-lsp"}'

        -- require actual init file
        require 'main'

        -- Install lazy
        local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        if not (vim.uv or vim.loop).fs_stat(lazypath) then
          local lazyrepo = "https://github.com/folke/lazy.nvim.git"
          local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
          if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
              { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
              { out, "WarningMsg" },
              { "\nPress any key to exit..." },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
          end
        end
        vim.opt.rtp:prepend(lazypath)

        -- Init lazy
        require 'lazy'.setup {
            spec = { { import = "plugins", }, },
            install = { colorscheme = {}, },
            readme = { enabled = false, },
            profiling = {
                loader = true,
                require = true,
            },
            pkg = { sources = { 'lazy' }, },
            rocks = { enabled = false, },
            headless = {
                task = false,
            },
        }
      '';
  };

  home.sessionVariables = {
    MANPAGER = "nvim +Man! -c ':set signcolumn=no'";
  };

  home.file =
    {
      ".config/nvim" = {
        source = ./config;
        recursive = true;
      };
    }
    // (let
      spellPath = ".local/share/nvim/site/spell";
    in {
      "${spellPath}/ru.utf-8.spl".source = inputs.nvim-spl-ru;
      "${spellPath}/ru.utf-8.sug".source = inputs.nvim-sug-ru;
      "${spellPath}/en.utf-8.spl".source = inputs.nvim-spl-en;
      "${spellPath}/en.utf-8.sug".source = inputs.nvim-sug-en;
    });
}
