command -q pueue && pueue completions fish | source
set -l group_commands add kill parallel pause start status wait

function _pueue_completer_groups
	pueue group | sed -nr 's/^Group "(.+)" \(([0-9]+ parallel)\): (.+)/\1\t\3: \2/p'
end

set -l group_options_args -x -o g -l group -a '(_pueue_completer_groups)'

function _pueue_completer_seen_tokens
	argparse 's/min=' 'x/max=' 'e/eq=' -- $argv
	set -l min "$_flag_min"
	set -l max "$_flag_max"

	if test -n "$_flag_eq"
		if test -n "$min$max"
			echo 'Cannot specify -e/--eq with -s/--min or -x/--max!' >&2
			return 1
		end
		set min $_flag_eq
		set max $_flag_eq
	end

	set -l tokens (commandline --cut-at-cursor --tokenize)
	set -l token_count (count $tokens)

	if test $token_count -lt $min -o $token_count -gt $max
		return 1
	end

	return 0
end

function _pueue_completer_task_ids
	pueue status 'columns=id,status,command status != Queued' \
	| _pueue_completer_task_id_filter
end

function _pueue_completer_editable_task_ids
	pueue status 'columns=id,status,command status != Queued status != Stashed' \
	| _pueue_completer_task_id_filter
end

function _pueue_completer_removable_task_ids
	pueue status 'columns=id,status,command status != Paused status != Running' \
	| _pueue_completer_task_id_filter
end

function _pueue_completer_running_task_ids
	pueue status 'columns=id,status,command status = Running' \
	| _pueue_completer_task_id_filter
end

function _pueue_completer_restartable_task_ids
	pueue status 'columns=id,status,command status != Paused status != Queued status != Running status != Stashed' \
	| _pueue_completer_task_id_filter
end

function _pueue_completer_task_id_filter
	awk '
	$2 == "Failed" {
		$2 = $2 $3
		$3 = ""
	}
	/^ [0-9]+/ {
		id = $1
		status = "[" $2 "]"
		$1 = $2 = ""
		gsub(/^[[:blank:]]+/, "", $0)
		printf "%s\t%-12s %s\n", id, status, $0
	}
	' \
	| sort -nr -k 1
end

complete -c pueue -n "__fish_seen_subcommand_from add" -d 'Assign the task to a group. Groups kind of act as separate queues. I.e. all groups run in parallel and you can specify the amount of parallel tasks for each group. If no group is specified, the default group willbe used' $group_options_args
complete -c pueue -n "__fish_seen_subcommand_from start" -d 'Resume a specific group and all paused tasks in it. The group will be set to running and its paused tasks will be resumed' $group_options_args
complete -c pueue -n "__fish_seen_subcommand_from pause" -d 'Pause a specific group' $group_options_args
complete -c pueue -n "__fish_seen_subcommand_from kill" -d 'Kill all running tasks in a group. This also pauses the group' $group_options_args
complete -c pueue -n "__fish_seen_subcommand_from status" -d 'Only show tasks of a specific group' $group_options_args
complete -c pueue -n "__fish_seen_subcommand_from format-status" -d 'Only show tasks of a specific group' $group_options_args
complete -c pueue -n "__fish_seen_subcommand_from wait" -d 'Wait for all tasks in a specific group' $group_options_args
complete -c pueue -n "__fish_seen_subcommand_from clean" -d 'Only clean tasks of a specific group' $group_options_args
complete -c pueue -n "__fish_seen_subcommand_from parallel" -d 'Set the amount for a specific group' $group_options_args

complete -c pueue -n "__fish_seen_subcommand_from edit" -f
complete -c pueue -n "__fish_seen_subcommand_from edit" -f -k -a '(_pueue_completer_editable_task_ids)'

complete -c pueue -n "__fish_seen_subcommand_from follow" -f
complete -c pueue -n "__fish_seen_subcommand_from follow" -f -k -a '(_pueue_completer_running_task_ids)'

complete -c pueue -n "__fish_seen_subcommand_from kill" -f
complete -c pueue -n "__fish_seen_subcommand_from kill" -f -k -a '(_pueue_completer_running_task_ids)'

complete -c pueue -n "__fish_seen_subcommand_from log" -f
complete -c pueue -n "__fish_seen_subcommand_from log" -f -k -a '(_pueue_completer_task_ids)'

complete -c pueue -n "__fish_seen_subcommand_from remove" -f
complete -c pueue -n "__fish_seen_subcommand_from remove" -f -k -a '(_pueue_completer_removable_task_ids)'

complete -c pueue -n "__fish_seen_subcommand_from restart" -f
complete -c pueue -n "__fish_seen_subcommand_from restart" -f -k -a '(_pueue_completer_restartable_task_ids)'

complete -c pueue -n "__fish_seen_subcommand_from send" -f
complete -c pueue -n "__fish_seen_subcommand_from send && _pueue_completer_seen_tokens -e 2" -f -k -a '(_pueue_completer_running_task_ids)'

complete -c pueue -n "__fish_seen_subcommand_from switch" -f
complete -c pueue -n "__fish_seen_subcommand_from switch" -f -k -a '(_pueue_completer_editable_task_ids)'
