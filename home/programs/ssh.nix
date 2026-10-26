{ ... }:

{

  services.ssh-agent = {
    enable = true;
    defaultMaximumIdentityLifetime = 3600;
  };
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        IdentitiesOnly = true;
        ServerAliveInterval = 30;
        ServerAliveCountMax = 3;
      };

      "github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_github";
        IdentitiesOnly = true;
      };
    };
  };
}
