function fissh --wraps=ssh
	if test (count $argv) -lt 1
		return 1
	end
	kitty +kitten ssh --kitten login_shell=fish -t $argv
end
