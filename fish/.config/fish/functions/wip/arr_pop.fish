function arr_pop
	return 1
	set -l varname $argv[1]
	for elem in $argv[2..-1]
		if set -l idx (contains -i -- $elem $$varname)
			set -e "$varname"[$idx]
		end
	end
end
			
