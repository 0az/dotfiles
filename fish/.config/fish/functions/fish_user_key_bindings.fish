# vim: set noexpandtab:
function fish_user_key_bindings
	if functions -q fzf_key_bindings
		fzf_key_bindings
	else if functions -q sk_key_bindings
		sk_key_bindings
	end

	# Cross-platform consistency
	# Ref: https://github.com/fish-shell/fish-shell/commit/2bb5cbc95943b0168c8ceb5b639391299e767e72
	bind --preset $argv alt-right nextd-or-forward-word
	bind --preset $argv alt-left prevd-or-backward-word
	bind --preset $argv ctrl-right forward-token
	bind --preset $argv ctrl-left backward-token

	bind --preset $argv alt-backspace backward-kill-word
	bind --preset $argv ctrl-backspace backward-kill-token
	bind --preset $argv alt-delete kill-word
	bind --preset $argv ctrl-delete kill-token
end
