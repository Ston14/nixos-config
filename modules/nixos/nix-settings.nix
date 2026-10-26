{ ... }:

{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      sandbox = true;
      require-sigs = true;

      trusted-users = [
        "root"
      ];

      # Dédupliquer les fichiers lors de leur ajout au store.
      auto-optimise-store = true;
    };

    # Ne pas lancer de déduplication périodique séparée.
    optimise.automatic = false;

    # Préserver les générations tant que la stratégie
    # de sauvegarde et de rétention n'est pas finalisée.
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 90d";
      persistent = true;
    };
  };
}
