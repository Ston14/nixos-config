
{ pkgs, ... }:

{
  imports = [
    ./tide.nix
  ];

  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];

    interactiveShellInit = ''
      set -g fish_greeting
    '';

    shellAliases = {
      ll = "ls -lah";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
  };
}


