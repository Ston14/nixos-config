{ pkgs, ... }:

{
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;

    # Keep OpenPGP and SSH identities separate
    enableSshSupport = false;

    # Fish integration sets GPG_TTY
    enableFishIntegration = true;

    # Passphrase cache
    defaultCacheTtl = 600;
    maxCacheTtl = 3600;

    # Terminal-based passphrase prompt
    pinentry.package = pkgs.pinentry-curses;
  };
}
