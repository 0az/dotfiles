#! /usr/bin/env bash

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd || exit 1)"
# source-path=SCRIPTDIR/..
. "$root/_scripts/_common.sh"

if ! command -v stow >/dev/null; then
	echo 'GNU Stow is not installed!' >&2
	exit 2
fi

export LC_ALL=C

default_packages=(
	shell
	ssh
	fish
)

mapfile -t other_packages < <(
	find ~/dotfiles -mindepth 1 -maxdepth 1 -type d \
	| sed "s@$HOME/dotfiles/@@; /[_.-]/d" \
	| grep -vxF -f <(printf '%s\n' "${default_packages[@]}") \
	| sort \
)

if test $# -ge 2; then
	exit 2
fi

run-command() {
	echo "$@"
	echo
	"$@"
}

command="${1:-}"

opts=(
	--dotfiles
	--dir="$root"
	--target="$HOME"
)

echo

case "$command" in
	""|install)
		run-command stow -S "${opts[@]}" "${default_packages[@]}"
		run-command stow -S "${opts[@]}" "${other_packages[@]}"
		;;

	uninstall)
		run-command stow -D "${opts[@]}" "${other_packages[@]}"
		run-command stow -D "${opts[@]}" "${default_packages[@]}"
		;;

	*)
		echo "Unrecognized subcommand: $1"
		exit 2
		;;
esac
