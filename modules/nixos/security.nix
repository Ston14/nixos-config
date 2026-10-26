{ ... }:

{
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  # Les permissions des clés SSH, GPG et age
  # sont gérées au niveau utilisateur.
}
