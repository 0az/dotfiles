source ~/.config/shell/profile
source ~/.config/shell/aliases

if command -q brew
	if test -d (brew --prefix)"/share/fish/completions"
		set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
	end

	if test -d (brew --prefix)"/share/fish/vendor_completions.d"
		set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
	end
end
