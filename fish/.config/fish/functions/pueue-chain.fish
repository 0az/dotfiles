function pueue-chain
	if ! set -q PUEUE_CHAIN_TASKS
		set -gx PUEUE_CHAIN_TASKS
	end
	if test -z "$PUEUE_CHAIN_GROUP"
		return 1
	end

	set -l args -p -g "$PUEUE_CHAIN_GROUP"
	if test -n "$PUEUE_CHAIN_TASKS[-1]"
		set -a task_args -a $PUEUE_CHAIN_TASKS[-1]
	end

	set -a PUEUE_CHAIN_TASKS (pueue add $args $argv)
	set -l exit_status $status
	echo "$PUEUE_CHAIN_TASKS[-1]"
	return $exit_status
end
