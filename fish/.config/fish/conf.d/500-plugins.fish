set -l vars function_partition function_left function_right complete_partition complete_left complete_right

set function_partition
set function_left
set function_right

set complete_partition
set complete_left
set complete_right

function _split_path -a type
	set -l relevant_path fish_"$type"_path
	set -l left "$type"_left
	set -l right "$type"_right
	set -l partition "$type"_partition
	for dir in $$relevant_path
		if test -z "$$partition"
			if string match -q "$HOME*" $dir
				set -a $left $dir
			else
				set $partition 1
				set -a $right $dir
			end
		else
			set -a $right $dir
		end
	end
end

_split_path function
status is-interactive && _split_path complete

for plugin_root in $__fish_config_dir/plugins/*
	set -a function_left $plugin_root/functions
	status is-interactive && set -a complete_left $plugin_root/completions
end
set fish_function_path $function_left $function_right
status is-interactive && set fish_complete_path $complete_left $complete_right

for plugin_root in $__fish_config_dir/plugins/*
	for f in $plugin_root/conf.d/*
		source $f
	end
end

set -e $vars
