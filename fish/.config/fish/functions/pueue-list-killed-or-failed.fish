function pueue-list-killed-or-failed --argument group
	set -l group_clause .group
	if test -n "$group"
		set group_clause ".group == \"$group\""
	end
	set -l jq '
		.tasks[]
		| select(
			'"$group_clause"'
			and (.status | type) == "object"
			and (
				.status.Done == "Killed"
				or .status.Done == "DependencyFailed"
				or (.status.Done | type) == "object"
					and .status.Done.Failed
			)
		).id
	'
	pueue status --json \
	| jq -Mr "$jq"
end
