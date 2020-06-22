function path_push -d 'Prepend arguments onto PATH (set -pgx PATH $argv)'
	set -pgx PATH $argv
end
