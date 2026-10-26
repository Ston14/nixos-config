{ ... }:

{
  imports = [
    ./programs/fish.nix
    ./programs/navigation.nix
    ./programs/git.nix
    ./programs/neovim.nix
  ];

  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
