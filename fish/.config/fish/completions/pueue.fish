command -q pueue && pueue completions fish | source
set -l group_commands add kill parallel pause start status wait

set -l group_options_args -x -o g -l group -a '(pueue group | sed -nr \'s/^Group "(.+)" \(([0-9]+ parallel)\): (.+)/\1\t\3: \2/p\')'

complete -c pueue -n "__fish_seen_subcommand_from add" -d 'Assign the task to a group. Groups kind of act as separate queues. I.e. all groups run in parallel and you can specify the amount of parallel tasks for each group. If no group is specified, the default group willbe used' $group_options_args
complete -c pueue -n "__fish_seen_subcommand_from start" -d 'Resume a specific group and all paused tasks in it. The group will be set to running and its paused tasks will be resumed' $group_options_args
complete -c pueue -n "__fish_seen_subcommand_from pause" -d 'Pause a specific group' $group_options_args
complete -c pueue -n "__fish_seen_subcommand_from kill" -d 'Kill all running tasks in a group. This also pauses the group' $group_options_args
complete -c pueue -n "__fish_seen_subcommand_from status" -d 'Only show tasks of a specific group' $group_options_args
complete -c pueue -n "__fish_seen_subcommand_from format-status" -d 'Only show tasks of a specific group' $group_options_args
complete -c pueue -n "__fish_seen_subcommand_from wait" -d 'Wait for all tasks in a specific group' $group_options_args
complete -c pueue -n "__fish_seen_subcommand_from clean" -d 'Only clean tasks of a specific group' $group_options_args
complete -c pueue -n "__fish_seen_subcommand_from parallel" -d 'Set the amount for a specific group' $group_options_args
