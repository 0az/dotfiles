function __enable_helper
	argparse 'q/quiet' -- $argv

	for environment in $argv
		eval $environment
		if test $status -ne 0
			if test ! $_flag_q
				echo "Activation of environment $argv[1] failed!" >&2
			end
			return 1
		end
	end
end
