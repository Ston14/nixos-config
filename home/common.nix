{ ... }:

{
  imports = [
    ./programs/fish.nix
    ./programs/navigation.nix
    ./programs/git.nix
    ./programs/neovim.nix
    ./programs/python.nix
    ./programs/rust.nix
    ./programs/go.nix
    ./programs/nix-tools.nix
    ./programs/eza.nix
    ./programs/btop.nix
    ./programs/freshfetch.nix
    ./programs/tmux.nix
    ./programs/direnv.nix
    ./programs/yazi.nix
    ./programs/ssh.nix
    ./programs/gnupg.nix
    ./programs/crypto.nix
    ./programs/docker.nix
    ./programs/security-cli.nix
    ./programs/network-cli.nix
  ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
