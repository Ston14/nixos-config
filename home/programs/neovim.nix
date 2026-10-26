{ config, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/home/dotfiles/nvim";
  };
}
