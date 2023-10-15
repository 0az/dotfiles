function pueue-list-successful --argument group
	set -l group_clause .group
	if test -n "$group"
		set group_clause ".group == \"$group\""
	end
	set -l jq '
		.tasks[]
		| select(
			'"$group_clause"'
			and (.status | type) == "object"
			and .status.Done == "Success"
		).id
	'
	pueue status --json \
	| jq -Mr "$jq"
end
