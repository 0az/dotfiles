function demo-magic
	true
end

if false
	# BEGIN HEREDOC
	if test -z "$type_speed"
		set -l type_speed 40
	end

	set -l comment_start (tput dim)
	set -l normal (tput sgr0)

	function prompt_hostname
		echo demo
	end

	function delay
		# tput sc
		# echo
		# read -sn 1 -P '' _tmp || true
		bash -c 'read -rs' >/dev/null 2>&1 || true
		# tput rc
	end

	function p
		# if string match '#*' $1
		# 	set cmd $comment_start"$argv"$normal
		# else
		# 	set cmd "$argv"
		# end
		set -l cmd "$argv"
		
		# delay_prompt
		fish_prompt
		delay

		if test -z $type_speed
			echo -en "$cmd"
		else
			echo -en "$cmd" | pv -qL (math "$type_speed + ( -2 + "(random)' % 5)')
		end

		delay
		echo
	end

	function pe
		p $argv
		eval $argv
	end
	# END HEREDOC
end
