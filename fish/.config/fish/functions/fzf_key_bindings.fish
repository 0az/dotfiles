for f in {/usr/local/opt,/opt/local/share}/fzf/shell/key-bindings.fish
	if test -e $f
		source $f
		break
	end
end
