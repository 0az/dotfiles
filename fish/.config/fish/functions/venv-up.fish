function venv-up --description 'Activate a Python venv'
	argparse --name=venv-up 'd/dir=' 'e/env=+' 'h/help' -- $argv

	if set -q _flag_h
		echo 'Usage' >&2
		printf '\tvenv-up [ -h | --help ]\n' >&2
		printf '\tvenv-up [ -d | --dir ] [ -e | --env ] COMMAND ...\n' >&2
		return 0
	end

	set -l prefix
	if ! set -q _flag_d
		if test -e .venv/bin/activate.fish
			set prefix .venv
		else if test -e venv/bin/activate.fish
			set prefix venv
		else if test -e ./bin/activate.fish
			set prefix .
		else if test -e Pipfile
			echo 'No venv found, but Pipfile detected.' >&2
			if set -q _flag_e
				echo 'Warning: Skipped loading .env files.' >&2
			end
			poetry shell
			return $status
		else
			echo 'No venv detected' >&2
			return 1
		end
	else
		set prefix (echo $_flag_d | sed 's@/$@@')
		if ! test -e "$prefix/bin/activate.fish"
			echo "No venv detected at $prefix" >&2
			return 1
		end
	end

	set subshell_args -i -C "source $prefix/bin/activate.fish" 

	if set -q _flag_e
		for file in $_flag_e
			set -a subshell_args -C "source-env $file"
		end
	end

	if test -n "$argv"
		if test $argv[1] = '--'
			shift
		end
		set -a subshell_args -c "$argv"
	end

	fish $subshell_args $argv
end
