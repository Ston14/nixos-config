{ pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "nixos";

  system.stateVersion = "26.05";

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
