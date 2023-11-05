source ~/.config/shell/profile

if status is-interactive
	source ~/.config/shell/aliases
	mkdir -p $XDG_CACHE_HOME/dotfiles

	if command -q brew
		if test -z "$brew_prefix" -o ! -d "$brew_prefix"
			set -U brew_prefix (brew --prefix)
		end
		if test -d "$brew_prefix/share/fish/completions"
			set -gx fish_complete_path $fish_complete_path $brew_prefix/share/fish/completions
		end

		if test -d "$brew_prefix/share/fish/vendor_completions.d"
			set -gx fish_complete_path $fish_complete_path $brew_prefix/share/fish/vendor_completions.d
		end
	end
end
