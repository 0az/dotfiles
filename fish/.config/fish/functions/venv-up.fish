function venv-up --description 'Activate a Python venv'
	argparse --name=venv-up 'd/dir=' 'e/env=+' 'h/help' -- $argv

	if set -q _flag_h
		echo 'Usage' >&2
		printf '\tvenv-up [ -h | --help ]\n' >&2
		printf '\tvenv-up [ -d | --dir ] [ -e | --env ] COMMAND ...\n' >&2
		return 0
	end

	if set -q VIRTUAL_ENV
		echo "Error: venv already active: $VIRTUAL_ENV" >&2
		return 1
	end

	set -l prefix
	# TODO: Clean up handling of special cases
	if ! set -q _flag_d
		if test -e .venv/bin/activate.fish
			set prefix .venv
		else if test -e venv/bin/activate.fish
			set prefix venv
		else if test -e ./bin/activate.fish
			set prefix .
		else if test -e Pipfile
			echo 'Error: No venv found, but Pipfile detected.' >&2
			if set -q _flag_e
				echo 'Warning: Skipped loading .env files.' >&2
			end
			pipenv shell
			return $status
		else if test -e Poetry.lock
			echo 'Error: No venv found, but Poetry.lock detected.' >&2
			if set -q _flag_e
				echo 'Warning: Skipped loading .env files.' >&2
			end
			poetry shell
			return $status
		else
			echo 'Error: No venv detected' >&2
			return 1
		end
	else
		set prefix (echo $_flag_d | string trim -r -c '/')
		if ! test -e "$prefix/bin/activate.fish"
			echo "Error: No venv detected at $prefix" >&2
			return 1
		end
	end

	set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

	set subshell_args -i \
		-C "source $prefix/bin/activate.fish" \
		-C "source "(status -f) \
		-C _venv_up_config_prompt \
		;

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

function _venv_up_config_prompt
	if not set -q VIRTUAL_ENV_PROMPT
		set -gx VIRTUAL_ENV_PROMPT (
			python --version \
			&| awk '
				BEGIN {
					version = ""
					suffix = ""
				}
				NR == 1 {
					version = $2
					gsub("\.[0-9]+$", "", version)
				}
				NR == 2 {
					$1 = tolower($1)
				}
				NR > 2 {
					exit
				}
				$1 ~ /pypy/ {
					suffix = "-pypy"
				}
				$1 ~ /jython/ {
					suffix = "-jython"
				}
				END {
					printf("py%s%s", version, suffix)
				}
			'
		)
	end

	# The following is taken from venv's activate.fish
	# Copyright (c) 2001-2021 Python Software Foundation; All Rights Reserved
	# SPDX: PSF-2.0
	# BEGIN VENV CODE

	# fish uses a function instead of an env var to generate the prompt.
	# Save the current fish_prompt function as the function _old_fish_prompt.
	functions -c fish_prompt _old_fish_prompt

	# With the original prompt function renamed, we can override with our own.
	function fish_prompt
		# Save the return status of the last command.
		set -l old_status $status

		# Output the venv prompt; color taken from the blue of the Python logo.
		printf "%s%s%s" (set_color 4B8BBE) "($VIRTUAL_ENV_PROMPT) " (set_color normal)

		# Restore the return status of the previous command.
		echo "exit $old_status" | .
		# Output the original/"old" prompt.
		_old_fish_prompt
	end
	function deactivate
		exit 0
	end

	set -gx _OLD_FISH_PROMPT_OVERRIDE "$VIRTUAL_ENV"

	# END VENV CODE
end
