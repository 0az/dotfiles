#! /usr/bin/env bash

set -euo pipefail

tmpdir=

cleanup() {
	echo
	echo
	echo "Cleaning up! tmpdir=$tmpdir"
	if test -n "$tmpdir" -a -d "$tmpdir"; then
		echo
		echo rm -Irf "$tmpdir"
		rm -Irf "$tmpdir"
	fi
	echo
}

trap cleanup EXIT

ensure-tmpdir() {
	if test -n "$tmpdir" -a -d "$tmpdir"; then
		test "$TMPDIR" != "$tmpdir" || exit 2
		return
	fi
	tmpdir="$(mktemp -d -t dotfiles-install.XXXX)"
	export TMPDIR="$tmpdir"
	test -d "$tmpdir" || exit 1
}

ensure-tmpfile() {
	if test $# -ge 2; then
		exit 2
	fi
	suffix="${1:-}"
	printf '%s%s\n' "$(mktemp)" "$suffix"
}

request-confirmation() {
	echo "Proposed command:"
	echo
	printf '\t%s\n' "$*"
	echo

	read -rp 'Execute? [Y/n] ' REPLY
	echo

	case "$REPLY" in
		n|N)
			echo 'Aborting before execution.'
			exit 1
			;;
		""|y|Y)
			# Intentionally left blank
			;;
		*)
			exit 1
			;;
	esac

}

run-command() {
	request-confirmation "$@"
	"$@" || exit 1
	echo
}

run-curl-bash() {
	url="$1"
	shift 1
	dest="$(ensure-tmpfile .sh)"
	run-command curl -#fSL "$url" -o "$dest"
	run-command /bin/bash "$dest" "$@"
}

start-section() {
	name="$1"
	printf '\n# %s\n\n' "$name"
}

install-homebrew() {
	start-section 'Install Homebrew'
	run-curl-bash https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
}

install-lix() {
	start-section 'Install Lix (Like Nix)'
	PATH="$PATH:/sbin" run-curl-bash https://install.lix.systems/lix install --no-modify-profile --enable-flakes --extra-conf 'use-xdg-base-directories = true'

	echo 'CAVEAT:'
	echo
	printf '\t%s\n' 'You may need to add the following to your shell profile:'
	echo
	printf '\t\t%s\n' '. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
	echo
}

ensure-tmpdir

if test -z "${SKIP_HOMEBREW:-}" -a "$(uname)" = Darwin; then
	install-homebrew
fi

if test -z "${SKIP_NIX:-}"; then
	install-lix
fi
