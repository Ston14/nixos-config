{ ... }:

{
  networking = {
    firewall.enable = true;
  };

  # Pas de serveur SSH sur ce WSL.
  services.openssh.enable = false;
}
