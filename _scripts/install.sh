#! /usr/bin/env bash

set -euo pipefail

tmpdir=

DRY_RUN="${DRY_RUN:-}"

cleanup() {
	start-section Cleanup
	echo "Cleaning up! tmpdir=$tmpdir"
	if test -n "$tmpdir" -a -d "$tmpdir"; then
		echo
		echo rm -Irf "$tmpdir"
		rm -Irf "$tmpdir"
	fi
	echo
}

trap cleanup EXIT

set +e
read -r -d '' awk_login_defs <<'EOF'
/SYS_UID_MIN/ {
	uid_min = $2
}

/SYS_UID_MAX/ {
	uid_max = $2
}

/SYS_GID_MIN/ {
	gid_min = $2
}

/SYS_GID_MAX/ {
	gid_max = $2
}

END {
	if (uid_min && uid_max && gid_min && gid_max) {
		print uid_min, uid_max, gid_min, gid_max
	}
}
EOF

read -r -d '' awk_number_in_range <<'EOF'
range_min <= int($0) && int($0) <= range_max {
	print $0
}
EOF

read -r -d '' awk_locate_free_range <<'EOF'
# Iterates over reverse sorted integer input, looking for a gap of at least range_size.
# Vars: range_size, range_min, range_max
{
	if (!lowest_used) {
		lowest_used = $0
		next
	}
	if (lowest_used - range_size > $0) {
		found = 1
		print lowest_used - range_size, lowest_used - 1
		exit 0
	}
	lowest_used = $0
}

END {
	if (found) {
		exit 0
	}

	if (lowest_used - range_size < range_min) {
		exit 1
	}

	print lowest_used - range_size, lowest_used - 1
}
EOF
set -e

awk-number-in-range() {
	awk \
		-v range_min="$1" \
		-v range_max="$2" \
		"$awk_number_in_range" \
	|| return $?
}

awk-locate-free-range() {
	awk \
		-v range_size="$1" \
		-v range_min="$2" \
		-v range_max="$3" \
		"$awk_locate_free_range" \
	|| return $?
}

configure-lix-nixbld() {
	declare lix_uid_base lix_uid_min lix_uid_max lix_gid

	# Find a safe range, or fall back to defaults
	read -r sys_uid_min sys_uid_max sys_gid_min sys_gid_max < <(
		awk "$awk_login_defs" /etc/login.defs
	) || return 0

	# shellcheck disable=SC2034
	read -r lix_uid_min lix_uid_max < <(
		cut -d : -f 3 /etc/passwd \
		| awk-number-in-range "$sys_uid_min" "$sys_uid_max" \
		| sort -nr \
		| awk-locate-free-range 32 "$sys_uid_min" "$sys_uid_max"
	) || return 0

	lix_uid_base=$((lix_uid_min - 1))

	# Check if $lix_uid_base is available, or search for an alternative otherwise
	if cut -d : -f 3 /etc/group | grep -q "$lix_uid_base"; then
		read -r lix_gid lix_gid < <(
			cut -d : -f 3 /etc/group \
			| awk-number-in-range "$sys_gid_min" "$sys_gid_max" \
			| sort -nr \
			| awk-locate-free-range 1 "$sys_gid_min" "$sys_gid_max" /etc/group
		) || [[ -n "$lix_gid" ]]
	else
		lix_gid="$lix_uid_min"
	fi

	echo "$lix_uid_base" "$lix_gid"
}

ensure-tmpdir() {
	if test -n "$tmpdir" -a -d "$tmpdir"; then
		test "$TMPDIR" != "$tmpdir" || exit 2
		return
	fi

	if test -n "$DRY_RUN"; then
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

	if test -n "$DRY_RUN"; then
		return
	fi

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

	if test -n "$DRY_RUN"; then
		return
	fi

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

section-homebrew() {
	start-section 'Install Homebrew'
	run-curl-bash https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
}

section-lix() {
	start-section 'Install Lix (Like Nix)'

	declare lix_uid_base lix_gid
	declare -a lix_nixbld_opts=()

	if test "$(uname)" = Linux -a -r /etc/login.defs; then
		echo 'Checking for free UIDs/GIDs...'
		echo

		if read -r lix_uid_base lix_gid < <(configure-lix-nixbld) || test -n "$lix_uid_base" -a "$lix_gid"; then
			lix_nixbld_opts+=(
				--nix-build-user-id-base "$lix_uid_base"
				--nix-build-group-id "$lix_gid"
			)
		fi
	fi

	PATH="$PATH:/sbin" run-curl-bash https://install.lix.systems/lix install --no-modify-profile --enable-flakes "${lix_nixbld_opts[@]+"${lix_nixbld_opts[@]}"}" --extra-conf 'use-xdg-base-directories = true'

	echo 'CAVEAT:'
	echo
	printf '\t%s\n' 'You may need to add the following to your shell profile:'
	echo
	printf '\t\t%s\n' '. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
	echo
}

run-sections() {
	section_cmds=()
	for section in "$@"; do
		case "$section" in
			homebrew)
				section_cmds+=(section-homebrew)
				;;
			lix)
				section_cmds+=(section-lix)
				;;
			*)
				echo "Invalid section! $section" >&2
				return 1
				;;
		esac
	done

	for section in "${section_cmds[@]}"; do
		"$section"
	done
}

sections=()

if test $# -eq 0 -o $# -eq 1 -a "${1:-}" = all; then
	if test -z "${SKIP_HOMEBREW:-}" -a "$(uname)" = Darwin; then
		sections+=(homebrew)
	fi

	if test -z "${SKIP_NIX:-}"; then
		sections+=(lix)
	fi
else
	sections=("$@")
fi

ensure-tmpdir

run-sections "${sections[@]}"
