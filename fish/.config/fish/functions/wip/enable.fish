# __enable__$environment
#
# Enable the environment $environment
#
# Returns:
# 	0 if successful, 1 otherwise.

function enable
	for option in $argv
		if functions -q "__enable__$option"
			set -al environments $option
		else
			echo "$option is not a valid environment" >&2
			return 1
		end
	end
	__enable_helper $environments
end
