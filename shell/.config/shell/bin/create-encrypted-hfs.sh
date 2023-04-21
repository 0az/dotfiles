#! /bin/bash

set -euo pipefail

help="
Usage:
	${0##*/} name path
"
help() {
	echo "$help"
}

if test $# -lt 2 -o $# -gt 2; then
	help >&2
	exit 1
fi

name="$1"
path="$2"

if test -d "$path"; then
	path="$path/$name.dmg"
fi

hdiutil create -type UDIF -encryption AES-256 -fs 'Case-sensitive Journaled HFS+' -volname "$name" -size 100MB "$path"
hdiutil attach "$path"
