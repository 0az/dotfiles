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
				.status.Done.result == "Killed"
				or .status.Done.result == "DependencyFailed"
				or (.status.Done.result | type) == "object"
					and .status.Done.result.Failed
			)
		).id
	'
	pueue status --json \
	| jq -Mr "$jq"
end
