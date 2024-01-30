function pueue-is-running -a task
	return (test (pueue status --json | jq -r ".tasks | . [\"$task\"].end") = 'null')
end
