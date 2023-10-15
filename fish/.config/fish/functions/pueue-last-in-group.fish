function pueue-last-in-group --argument group
	if test -z "$group"
		return 1
	end
	pueue status --json | jq -Mr '.tasks | to_entries | map(select(.value.group == "'"$group"'").key) | max // halt_error'
end
