{ ... }:

{
  imports = [
    ./nix-settings.nix
    ./security.nix
    ./networking.nix
    ./docker.nix
  ];

  # Configuration commune aux différents hôtes NixOS.
  #
  # Ajouter ici uniquement les paramètres réellement
  # partagés entre WSL et un futur laptop.
}
