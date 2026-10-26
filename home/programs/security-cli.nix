{ pkgs, ... }:

{
  home.packages = with pkgs; [
    jq
    yq
    sqlite
    file
    hexyl
    yara
    duckdb
  ];
}
