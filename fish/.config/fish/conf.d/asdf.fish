if status is-interactive && test -n "$ASDF_CONFIG_FILE" -a -n "$ASDF_DATA_DIR" -a -e "$ASDF_CONFIG_FILE" -a -d "$ASDF_DATA_DIR"
  set -l asdf_dir $XDG_DATA_HOME/asdf
  if test -n "$brew_prefix"
    set asdf_dir $brew_prefix/opt/asdf
    set -p fish_complete_path $asdf_dir/share/fish/vendor_completions.d
  end
  set -l asdf_script $asdf_dir/libexec/asdf.fish
  test -e $asdf_script || return
  source $asdf_script
  set -a fish_complete_path $asdf_dir/completions
end
