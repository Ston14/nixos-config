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
  home-manager.users.nixos.programs.tmux.extraConfig = ''
  # WSL : copie vers le presse-papiers Windows
  bind -T copy-mode-vi y send -X copy-pipe-and-cancel "clip.exe"
  '';
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
