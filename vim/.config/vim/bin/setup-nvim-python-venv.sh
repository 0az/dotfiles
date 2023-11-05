#! /bin/sh

set +eu

venv_dir="${XDG_DATA_HOME:-"$HOME/.local/share"}/nvim/venv"
venv_python="$venv_dir/bin/python3"

if ! test -x "$venv_python"; then
	rm -rf "$venv_dir"
	python3 -m venv "$venv_dir"
fi

"$venv_python" -m pip install -U pip pynvim
"$venv_python" -c 'import pynvim; print(pynvim.VERSION)'
