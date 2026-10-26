{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rustc
    cargo
    rust-analyzer
    rustfmt
    clippy
  ];

  home.sessionVariables = {
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
  };
}
