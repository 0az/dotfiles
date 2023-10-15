#! /bin/bash

set -euo pipefail

cwd_name=${PWD##*/}
cwd_name=${cwd_name:-/}
debug="${DEBUG:-}"

obsidian_common="${XDG_DATA_HOME:-$HOME/.local/share}/obsidian-common"

if test "$cwd_name" != '.obsidian'; then
	if ! test -d .obsidian/; then
		exit 1
	fi
	cd .obsidian || exit 1
fi

errors=()
for f in "$obsidian_common"/*; do
	name="${f##*/}"
	# shellcheck disable=SC2015
	if test -e "$name" -a ! -L "$name"; then
			errors+=("$name")
	fi
done

if test "${#errors[@]}" -ne 0; then
	echo 'Encountered conflicting files!' >&2
	for name in "${errors[@]}"; do
		file --no-dereference "$name"
	done | sed "s@$HOME@~@" >&2
	exit 1
fi

for f in "$obsidian_common"/*; do
	ln -sf "$f" .
done
