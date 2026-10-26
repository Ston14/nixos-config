{ pkgs, ... }:

{
  
  wsl.enable = true;
  wsl.defaultUser = "nixos";

  system.stateVersion = "26.05";
  users.users.nixos.shell = pkgs.fish;
  programs.fish.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    git
    tmux
    neovim
    ripgrep
    fd
    gcc
    unzip
    zoxide
    yazi
    vimPlugins.LazyVim
    tree-sitter
    curl
    fzf
    lazygit
    uv
  ];
}
