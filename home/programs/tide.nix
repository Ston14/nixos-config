
{ lib, ... }:

{
  programs.fish.interactiveShellInit = lib.mkAfter ''
    # Tide - Lean Developer
    # Declarative configuration, no Nerd Font

    # Layout
    set -gx tide_left_prompt_items pwd git newline character
    set -gx tide_right_prompt_items status cmd_duration direnv python rustc go nix_shell

    # Lean layout
    set -gx tide_left_prompt_frame_enabled false
    set -gx tide_right_prompt_frame_enabled false

    set -gx tide_left_prompt_prefix ""
    set -gx tide_left_prompt_suffix " "
    set -gx tide_right_prompt_prefix " "
    set -gx tide_right_prompt_suffix ""

    set -gx tide_left_prompt_separator_same_color " "
    set -gx tide_left_prompt_separator_diff_color " "
    set -gx tide_right_prompt_separator_same_color " "
    set -gx tide_right_prompt_separator_diff_color " "

    set -gx tide_prompt_icon_connection " "
    set -gx tide_prompt_color_frame_and_connection 6C6C6C
    set -gx tide_prompt_color_separator_same_color 949494

    set -gx tide_prompt_pad_items false
    set -gx tide_prompt_add_newline_before false
    set -gx tide_prompt_transient_enabled false
    set -gx tide_prompt_min_cols 34

    # Prompt character - ASCII compatible
    set -gx tide_character_icon ">"
    set -gx tide_character_vi_icon_default ">"
    set -gx tide_character_vi_icon_replace ">"
    set -gx tide_character_vi_icon_visual ">"

set -gx tide_character_color 5FD700
set -gx tide_character_color_failure FF0000

    # Directory
    set -gx tide_pwd_color_anchors 00AFFF
    set -gx tide_pwd_color_dirs 0087AF
    set -gx tide_pwd_color_truncated_dirs 8787AF
    set -gx tide_pwd_icon ""
    set -gx tide_pwd_icon_home ""

    # Git
    set -gx tide_git_icon ""
    set -gx tide_git_color_branch 5FD700
    set -gx tide_git_color_dirty D7AF00
    set -gx tide_git_color_staged D7AF00
    set -gx tide_git_color_untracked 00AFFF
    set -gx tide_git_color_conflicted FF0000
    set -gx tide_git_color_operation FF0000
    set -gx tide_git_color_upstream 5FD700
    set -gx tide_git_color_stash 5FD700
    set -gx tide_git_truncation_length 24

    # Status
    set -gx tide_status_bg_color normal
    set -gx tide_status_bg_color_failure normal
    set -gx tide_status_color 5FAF00
    set -gx tide_status_color_failure D70000
    set -gx tide_status_icon ""
    set -gx tide_status_icon_failure "!"

    # Command duration
    set -gx tide_cmd_duration_threshold 3000
    set -gx tide_cmd_duration_decimals 0
    set -gx tide_cmd_duration_color 87875F
    set -gx tide_cmd_duration_icon ""

    # Development environments
    set -gx tide_python_icon ""
    set -gx tide_python_color 00AFAF
    set -gx tide_rustc_icon ""
    set -gx tide_rustc_color F74C00
    set -gx tide_go_icon ""
    set -gx tide_go_color 00ACD7
    set -gx tide_nix_shell_icon ""
    set -gx tide_nix_shell_color 7EBAE4
    set -gx tide_direnv_icon ""
    set -gx tide_direnv_color D7AF00

    # Context
    set -gx tide_context_always_display false
    set -gx tide_context_hostname_parts 1
  '';
}

