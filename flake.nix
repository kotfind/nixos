{
  description = "NixOS configuration";

  inputs = {
    # -------------------- General --------------------

    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-dash-docsets = {
      url = "github:boinkor-net/nix-dash-docsets";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    alacritty-fcitx-patch.url = "github:kotfind/alacritty-fcitx-patch";

    homepage.url = "github:kotfind/homepage";

    hostlib.url = "github:kotfind/hostlib";

    # -------------------- Toki Pona --------------------

    fcitx5-ilo-sitelen = {
      url = "github:kotfind/ilo-sitelen";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    nasin-nanpa = {
      url = "github:kotfind/nasin-nanpa";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # -------------------- NeoVim --------------------

    codeium = {
      url = "github:Exafunction/codeium.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # -------------------- NeoVim.Spelling --------------------

    nvim-spl-ru = {
      url = "https://ftp.nluug.nl/pub/vim/runtime/spell/ru.utf-8.spl";
      flake = false;
    };
    nvim-sug-ru = {
      url = "https://ftp.nluug.nl/pub/vim/runtime/spell/ru.utf-8.sug";
      flake = false;
    };
    nvim-spl-en = {
      url = "https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.spl";
      flake = false;
    };
    nvim-sug-en = {
      url = "https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.sug";
      flake = false;
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://kotfind.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos-cuda.org"
    ];
    extra-trusted-public-keys = [
      "kotfind.cachix.org-1:cDNHNDd9T5j4Xpb5XOipX4CXoRhD/jPLGXVdlIa8g94="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  outputs = inputs: let
    system = "x86_64-linux";
    args = inputs // {inherit system;};
  in {
    nixosConfigurations = import ./default.nix args;
  };
}
