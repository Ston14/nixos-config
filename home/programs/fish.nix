{ ... }:

{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # Disable default greeting
      set -g fish_greeting
    '';

    shellAliases = {
      ll = "ls -lah";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
  };
}
