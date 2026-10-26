
{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Ne pas générer ~/.config/nvim/init.lua
    sideloadInitLua = true;
  };

  home.packages = with pkgs; [
    trash-cli
    ripgrep
    fd
    gcc
    unzip
    tree-sitter
    curl
    lazygit
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/home/dotfiles/nvim";
  };
}

