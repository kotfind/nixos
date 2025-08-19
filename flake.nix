{
  description = "NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # -------------------- General --------------------
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

  outputs = inputs: let
    system = "x86_64-linux";
    args = inputs // {inherit system;};
  in {
    nixosConfigurations.default = import ./default.nix args;
  };
}
